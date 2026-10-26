# Medzee

**A beautiful, intelligent medicine companion.** Medzee helps you take the right
dose at the right time, keeps your stock counts honest, and shows you exactly how
consistent you've been — all offline, all on-device, all private.

Built with Flutter 3, Material 3 (customized), Riverpod, GoRouter, and Drift
(SQLite). Ships with **125 automated tests** covering the domain logic, services,
and key screens.

---

## Table of contents

- [Quick start](#quick-start)
- [Feature overview](#feature-overview)
- [Architecture](#architecture)
- [Project structure](#project-structure)
- [Testing](#testing)
- [Medical-safety rules](#medical-safety-rules)
- [External services](#external-services)
- [Environment setup](#environment-setup)
- [Known limitations](#known-limitations)

---

## Quick start

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate Drift database code (only needed after changing tables.dart)
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run

# 4. Run the test suite
flutter test

# 5. Static analysis
flutter analyze

# 6. Build a debug APK
flutter build apk --debug
```

Requirements: Flutter SDK `^3.7.0` with Dart `^3.7.0`. Android minSdk 24+
(biometric / notification scheduling), targetSdk current. iOS 13+.

---

## Feature overview

### Today (home)

- **Time-aware timeline.** Today's doses ordered by clock time with the next
  actionable dose surfaced first. Pending doses can be **taken** or **skipped**
  directly from the tile; taken doses deduct stock and show the remaining count
  in the confirmation snackbar.
- **Adherence at a glance.** "3 of 5 taken" progress ring for the current day.
- **Graceful states.** Loading, error (with retry-safe messaging), and a guided
  empty state when nothing is scheduled.

### Medicine library

- **Search & filter.** Instant search across names and generic/active
  ingredients, plus status chips (Active / Paused / Completed / Archived).
- **Rich tiles.** Stock chip (`30 tablet` or `Low · 4 left`), rolling adherence
  chip (`92% taken`), and form-appropriate iconography.
- **Full detail screen.** Schedule phases, stock history, refill/adjust stock,
  pause / resume / end treatment / archive, and the complete dose history.

### Add-medicine wizard

Four steps — *About the medicine → How and when → Stock → Review* — with:

- **Every schedule shape:** daily, specific weekdays, every N hours, every N
  days, specific days of the month, fully custom, and **as-needed (PRN)**.
- **Multiple phases** per medication (e.g. titration: 10 mg for two weeks,
  then 20 mg) with overlap validation.
- **Validated persistence.** The wizard validates before writing and never
  saves a partial medication; the Review step shows exactly what will be stored.

### Reminders & notifications

- **Timezone-correct scheduling.** Doses are generated in wall-clock time and
  converted through the IANA timezone database, so reminders survive
  daylight-saving transitions.
- **Travel mode.** Reminders can stay on your own ("home") time zone while your
  phone is somewhere else, with both clocks shown. Pick any time zone, switch it
  on or off in Profile, or accept the offer on Home when the phone changes zone.
- **Several people, one app.** Each person has their own medicines, reminders and
  sync code; switch between them from Home or Profile.
- **Exact alarms** on Android (`SCHEDULE_EXACT_ALARM`), pre-reminders, missed-dose
  follow-ups, quiet hours, and a daily summary — all configurable per profile.
- **Actionable notifications.** Take / skip straight from the notification via a
  typed action dispatcher wired into the router.

### Inventory

- **Automatic deduction** on every confirmed dose with a complete
  **audit trail** (refills, adjustments, dose deductions, reversals).
- **Idempotent.** Marking a dose taken twice — or correcting taken → skipped →
  taken — moves stock exactly once per actual decision.
- **Low-stock alerts** with configurable thresholds and refill-date projections
  based on the real upcoming-dose calendar.

### Insights

- Rolling 7/30/90-day adherence percentages, per-medication breakdowns, streaks,
  and a calendar view of past days (taken / missed / skipped / pending).
- PRN medicines are excluded from adherence math by design.

### Privacy & safety

- **100% offline.** No account, no telemetry, no third-party data collection.
- Optional biometric app lock, notification privacy levels (hide medicine names),
  and on-device-only storage (`flutter_secure_storage` for secrets, Drift for data).

---

## Architecture

Layered architecture with unidirectional dependencies — presentation never
touches SQL, and domain never imports Flutter:

```
presentation  (screens, widgets, design system)
     │  watches / reads
state         (Riverpod providers, controllers)
     │  calls
services      (DoseService, MedicationService, NotificationService,
     │         ScheduleService, TimezoneService, MedicineInfoService)
     │  implements / uses
domain        (models, enums, repository interfaces, pure calculators)
     ▲  implemented by
data          (Drift tables, DAO-backed repository implementations, mappers)
```

**Key rules:**

- The **domain layer** is pure Dart: no Flutter, no Drift, no platform channels.
  All business logic that must be right lives here and is unit-tested.
- **Repository interfaces** live in `domain/repositories`; Drift implementations
  live in `data/repositories`. Services and providers depend only on the
  interfaces — every widget test runs against in-memory fakes.
- **Services own writes.** Screens never write to repositories directly; they
  call a service so a medication, its schedule, its stock and its reminders
  always move together.
- **DI via Riverpod** (`lib/state/providers.dart`). `appDatabaseProvider` must be
  overridden at startup (see `main.dart`), which keeps tests honest.

See [ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full write-up, including the
scheduling pipeline and the notification lifecycle.

---

## Project structure

```
lib/
├── main.dart                  # bootstrap: DB override, timezone init, runApp
├── core/theme/                # colors, typography (Inter), spacing, motion,
│                              #   status colors, ThemeData builders (M3)
├── domain/
│   ├── models/                # Medication, SchedulePhase, Dose, Inventory, …
│   ├── repositories/          # abstract repository contracts
│   └── services/              # pure logic: ScheduleGenerator,
│                              #   DoseStatusResolver, MedicationValidator,
│                              #   AdherenceCalculator, InventoryCalculator,
│                              #   LocalTimeConverter
├── data/
│   ├── local/                 # Drift tables + AppDatabase (schema v1)
│   ├── repositories/          # Drift-backed implementations
│   └── mappers.dart           # row <-> model conversions (no logic leaks)
├── services/                  # DoseService, MedicationService, ScheduleService,
│                              #   NotificationService (+ action dispatcher),
│                              #   TimezoneService, MedicineInfoService (openFDA)
├── state/                     # Riverpod providers, DoseActions, library filter
├── routing/                   # GoRouter config, route constants
└── presentation/              # shell + home, medicines (+wizard, detail),
                               #   calendar, insights, profile, onboarding,
                               #   shared design-system widgets
test/
├── domain/services/           # pure-logic suites (generator, resolver,
│                              #   validator, adherence, inventory, timezone)
├── services/                  # DoseService behavioural suite (17 tests)
├── presentation/              # widget tests: home, library, wizard
└── helpers/fakes.dart         # shared in-memory repository fakes
```

---

## Testing

```bash
flutter test                 # all 125 tests
flutter test test/domain/    # pure domain logic
flutter test test/presentation/
```

**Coverage highlights**

| Area | What's proven |
| --- | --- |
| `ScheduleGenerator` | every schedule kind, phase transitions, month-end edge cases (e.g. day 31), interval math, open-ended courses |
| `DoseStatusResolver` | pending/due/missed/cancelled windows and boundary conditions |
| `MedicationValidator` | every rejection rule, including PRN-with-times and phase overlap |
| `AdherenceCalculator` | PRN exclusion, future-dose exclusion, per-med and windowed percentages |
| `InventoryCalculator` | deduction, clamping at zero, refill projections |
| `LocalTimeConverter` | wall-clock ↔ UTC across DST transitions (both spring & autumn) |
| `DoseService` | 17 behavioural tests: idempotent take/skip, stock reversal on correction, unit-mismatch refusal, exact audit trails |
| Widget tests | home timeline (render, take action, stock snackbar, navigation), library (chips, search, filters, empty states), wizard (gating, PRN flow & regression) |

The widget tests run the **real services** on in-memory repositories — no mocks
that can drift from the real contracts. Two production bugs were caught and fixed
by this suite (see git history).

---

## Medical-safety rules

Medzee is a tracking companion, **not** a prescriber. These rules are enforced in
business logic, not just in copy:

1. **Never prescribes.** No dose suggestions, no drug interactions, no clinical
   recommendations. The wizard asks for facts as printed on the label.
2. **Never invents clinical facts.** Medicine information (when enabled) comes
   exclusively from openFDA label data with visible source attribution, and the
   UI always presents it as reference material, never advice.
3. **Never auto-doubles a missed dose.** A missed dose stays missed; the app
   will not silently schedule a catch-up dose. Corrections are explicit user
   actions with full audit history.
4. **No silent schedule corruption.** The validator rejects contradictory
   schedules (empty times, overlapping phases, impossible intervals) *before*
   persistence; the schedule normaliser clamps rather than guesses.
5. **Graceful degradation.** If exact-alarm permission is missing, the app says
   so loudly instead of silently never reminding.

---

## External services

Medzee works fully offline. These integrations are **optional** and documented
in [docs/EXTERNAL_SERVICES.md](docs/EXTERNAL_SERVICES.md):

| Service | Purpose | Key required? | Default |
| --- | --- | --- | --- |
| **openFDA** (`api.fda.gov`) | Drug label reference, **INN/generic-first** — the naming Indian law requires on every strip, so Indian medicines resolve by their generic name | No (free tier, rate-limited) | Enabled, key-less |
| **Firebase (FCM + Auth)** | Push channel + auth seam, wired behind feature detection — activates when `google-services.json` is present | — | Optional, off until configured |

**Not implemented / out of scope by design:** cloud sync, multi-device accounts,
pharmacy price lookups, drug-interaction checkers, AI dosing advice. The
repository and provider seams make each of these additive without refactoring.

> **A note on medicine info in India:** no free public India-specific
> drug-label API exists (CDSCO publishes none). Lookups therefore key off the
> INN generic name printed on every Indian strip. Brand names like Dolo or
> Crocin aren't in the database — type the generic name (e.g. Paracetamol),
> which the wizard captures in its "active ingredient" field.

**Not implemented / out of scope by design:** cloud sync, multi-device accounts,
pharmacy price lookups, drug-interaction checkers, AI dosing advice. The
repository and provider seams make each of these additive without refactoring.

---

## Environment setup

No environment variables are required to run. Optional settings:

| Variable | Where | Purpose |
| --- | --- | --- |
| `OPENFDA_API_KEY` | `dart-define` (`--dart-define=OPENFDA_API_KEY=...`) | Raises openFDA rate limits from 240 req/day to 120k req/day |

Android notification behaviour depends on runtime permissions (POST_NOTIFICATIONS
on API 33+, SCHEDULE_EXACT_ALARM). The app detects and explains missing
permissions in Settings rather than failing silently.

For release builds, add your own signing config; the repo intentionally ships
debug signing only.

---

## Known limitations

- **Android-first.** iOS compiles (usage descriptions are in place) but
  notification scheduling has only been verified on Android; treat iOS as
  untested until validated on device.
- **Barcode scanning & photo capture** use `mobile_scanner` / `image_picker`
  with graceful fallbacks, but are best verified on a physical device.
- **Medicine-info coverage is INN/generic-based.** Indian brand names aren't
  in openFDA; search by the generic name printed on the strip (always present
  by law). No India-specific public API exists to plug in instead.
- **No doctor report export (PDF)** yet — insights are on-screen only.

See [docs/KNOWN_LIMITATIONS.md](docs/KNOWN_LIMITATIONS.md) for the living list.

---

## License

Proprietary — © 2026 Medzee. All rights reserved. (Adjust before any public
release.)
