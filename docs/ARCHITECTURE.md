# Medzee — Architecture

This document explains how Medzee is put together: the layering, the scheduling
pipeline, the notification lifecycle, and the safety invariants the code is
built around. For feature documentation see [README.md](../README.md).

---

## 1. Layers and dependency rules

```
┌─────────────────────────────────────────────────────────────┐
│ presentation   screens, widgets, design system              │
│      │ watches / reads                                      │
│ state          Riverpod providers + controllers             │
│      │ calls                                                 │
│ services       application services (writes, coordination)  │
│      │ uses                                                  │
│ domain         models · repository interfaces · pure logic  │
│      ▲ implements                                            │
│ data           Drift tables · repository implementations    │
└─────────────────────────────────────────────────────────────┘
```

**Hard rules**

1. `domain/` imports no Flutter, no Drift, no platform channels. Everything in
   it is plain Dart and plain testable.
2. `presentation/` never imports `data/`. Screens watch providers and call
   services. There is no SQL, DAO, or Drift type in any widget.
3. Only `services/` performs writes. A screen that "saves" calls a service;
   the service owns the transaction (medication + phases + stock + reminders).
4. Repositories are defined as abstract contracts in `domain/repositories/`
   and implemented against Drift in `data/repositories/`. Tests substitute
   in-memory fakes (`test/helpers/fakes.dart`).

**Why this shape:** the medically-critical code (schedule expansion, dose
status windows, stock accounting, validation) must be provably correct without
a device, a database, or a UI. Keeping it pure makes that possible — most of
the test suite runs in milliseconds.

---

## 2. Key building blocks

### Domain services (pure)

| Class | Responsibility |
| --- | --- |
| `ScheduleGenerator` | Expands a `SchedulePhase` (kind + times + weekdays/intervals/monthly days) into concrete `ScheduledDose` rows for a date range. Handles month-length edge cases (day 31 in a 30-day month) and multi-phase timelines. |
| `DoseStatusResolver` | Decides whether a scheduled dose is pending / due / missed / cancelled at a given instant, given the medication's reminder-window settings. |
| `MedicationValidator` | Rejects incomplete or contradictory schedules before persistence (no times for a scheduled kind, times for PRN, overlapping phases, bad intervals). |
| `AdherenceCalculator` | Windowed taken/missed percentages. Excludes PRN (no fixed expectations) and future doses (not yet resolvable). |
| `InventoryCalculator` | Stock math: deductions, zero clamping, refill-date projections from the upcoming-dose calendar. |
| `LocalTimeConverter` | Wall-clock ↔ UTC conversion via IANA zones; the DST-safe contract every other component relies on. |

### Application services

| Class | Responsibility |
| --- | --- |
| `DoseService` | The take/skip/miss/correct decision engine. Every stock movement is idempotent and audited; corrections reverse exactly what was deducted. |
| `MedicationService` | Creates, updates, pauses, retires medications — always together with schedule, stock and reminders. Validates and normalises before any write. |
| `ScheduleService` | Keeps generated dose rows and scheduled notifications in sync with the current phases. |
| `NotificationService` | Thin wrapper over `flutter_local_notifications`: permission checks, exact-alarm scheduling, quiet hours, privacy levels, action channels. |
| `NotificationActionDispatcher` | Seam between notification taps and GoRouter; converts payloads into typed navigation/dose actions. |
| `TimezoneService` | Loads the IANA database, resolves the device zone, exposes the converter. |
| `MedicineInfoService` | Optional openFDA label lookup behind `MedicineInfoProvider` (repository seam in `domain/repositories/medicine_info_repository.dart`). |

### State layer

Providers in `lib/state/` expose streams/futures of domain objects. Notables:

- `appDatabaseProvider` — **must be overridden** at startup; it throws otherwise.
  This single rule guarantees tests never touch a real database by accident.
- `todayTimelineProvider` — merges today's doses with medications and computes
  the single "next" dose for the timeline.
- `doseActionsProvider` — exposes `DoseActions` (take/skip/correct) with a
  medication lookup so the UI never assembles services by hand.
- `libraryFilterProvider` — pure in-memory Notifier for search/status/sort.

---

## 3. Scheduling pipeline

```
SchedulePhase (daily 08:00, 20:00 · Mar 1 → Mar 14)
        │
        ▼  ScheduleGenerator (domain)
List<ScheduledDose>  — wall-clock minutes per local date
        │
        ▼  LocalTimeConverter (IANA zone)
UTC instants for persistence & alarm scheduling
        │
        ▼  DoseRepository (Drift)
Rows in `scheduled_doses`  — single source of truth for the timeline
        │
        ▼  NotificationService
Exact alarms per dose (+ optional pre-reminder / follow-up / quiet hours)
```

Why the two-step conversion: humans think in wall-clock time ("8 AM daily"),
devices schedule in absolute time. Expanding first in wall-clock and converting
per occurrence keeps reminders correct across DST transitions — a dose at 08:00
local stays at 08:00 local on both sides of a clock change. This is covered by
the timezone test suite, which asserts behaviour across a spring-forward and an
autumn-back transition.

---

## 4. Stock accounting (audit-safe and idempotent)

Every stock change is a row in `inventory_transactions`:

- **Deduction on take.** `DoseService` writes the transaction and the new
  quantity atomically; the log carries `inventoryTransactionId`.
- **Idempotency.** Transactions keyed by `doseLogId`; re-taking the same dose
  cannot deduct twice. Double-taps, notification action + in-app action, replay
  — all collapse to one movement.
- **Corrections.** Changing taken → skipped reverses *exactly* what was deducted
  (never an estimated amount); changing skipped → taken deducts once. Every
  superseded log is kept (`supersedesLogId`) so history is never rewritten.
- **Clamping with honest audit.** Stock can't go below zero; the transaction
  records the clamped delta, so the audit trail always reconciles.
- **Refusal rules.** A take that would deduct the wrong unit (e.g. tablets from
  an mL stock) or a fractional discrete unit (½ tablet) is refused loudly rather
  than recorded wrongly.

These properties are enforced by the 17-test `DoseService` suite.

---

## 5. Notifications

- Android: `SCHEDULE_EXACT_ALARM` + `POST_NOTIFICATIONS` permissions, three
  channels (dose reminders, pre-reminders, daily summary). The manifest declares
  receivers for boot-reschedule and timezone-change-reschedule.
- Notification taps dispatch through `NotificationActionDispatcher`, which the
  router consumes — no stringly-typed payload parsing inside the plugin layer.
- Quiet hours and privacy levels (hide medicine names on the lock screen) are
  applied at schedule time, not display time, so nothing sensitive is ever
  queued to the OS during quiet hours.

---

## 6. Data layer

Drift schema lives in `lib/data/local/tables.dart` (schema version 1):
`medications`, `schedule_phases`, `scheduled_doses`, `dose_logs`,
`inventory`, `inventory_transactions`, `notification_schedules`, `profiles`.

- Enums are stored as strings via converters in `data/mappers.dart`; the domain
  never sees storage encodings.
- All streams used by the UI (`watchAll`, `watchDosesForDate`, …) are Drift
  `.watch()` queries, so the whole UI is reactive to writes with no manual
  invalidation — with one deliberate exception: the wizard invalidates
  `medicationsProvider` after a save to guarantee a fresh list before
  navigation lands.
- Tests use `AppDatabase.forTesting(...)` when a real DB is needed and in-memory
  fakes everywhere else.

---

## 7. Navigation

GoRouter with a typed route table in `lib/routing/app_router.dart`
(`AppRoutes.*` constants — no raw path strings in widgets). The app shell
(`presentation/shell/app_shell.dart`) owns the bottom navigation and keeps tab
state alive via `StatefulShellRoute`.

---

## 8. Design system

`core/theme/` defines tokens, not one-off styles: `AppColors`, `AppSpacing`,
`AppRadii`, `AppMotion` (durations + curves), `AppTypography` (bundled Inter),
and `AppStatusColors` (taken / missed / skipped / due / warning + containers,
theme-adaptive). Both light and dark themes are full `ColorScheme`s built from
the same tokens. Screens compose from `presentation/shared/app_widgets.dart`
(AppCard, StatusChip, EmptyState, InfoBanner, SectionHeader, ThinProgress,
AppPrimaryButton/AppSecondaryButton) — no per-screen button styling.

---

## 9. Testing strategy

| Level | What | How |
| --- | --- | --- |
| Unit | Domain calculators & validators | Plain `test()` — no Flutter binding |
| Service | `DoseService` behavioural rules | Real service + in-memory fakes |
| Widget | Home timeline, library, wizard | Real services + fakes, real `GoRouter`, provider overrides |
| Integration | (boundary) | `integration_test` wired; runs on device/emulator |

The widget suites exercise the real provider graph with only three seams
overridden (timeline stream, active profile, action entry point), so they catch
integration mistakes (provider wiring, navigation, snackbar content) — not just
rendering.

Bugs caught by tests during development (kept as regression tests):

1. `DoseService` wrote the un-clamped quantity to the audit row when stock
   clamped at zero.
2. `FixedOffsetConverter.utcFromLocal` depended on the machine timezone.
3. The add-medicine wizard attached the default 08:00 time to PRN schedules,
   which the validator then rejected with an unfixable error (plus a subtle
   cascade-precedence crash on save found while testing the fix).
