# Feature list — implemented vs. external dependencies

Legend: ✅ fully implemented & tested · 🧪 implemented, needs device verification ·
🔌 seam exists, external service optional · ❌ intentionally not included

---

## Core tracking

| Feature | Status | Notes |
| --- | --- | --- |
| Today timeline with next-dose surfacing | ✅ | Widget-tested incl. take/skip actions |
| Take / skip / correct with audit history | ✅ | 17 service tests; superseded logs kept |
| Idempotent stock deduction & reversal | ✅ | Double-tap & correction safe |
| Multi-phase schedules (titration) | ✅ | Overlap validation enforced |
| Daily / weekly / every-N-hours / every-N-days / monthly / custom | ✅ | Generator unit-tested per kind |
| As-needed (PRN) medicines | ✅ | Excluded from adherence math by design |
| Calendar view of past doses | ✅ | |
| Insights: 7/30/90-day adherence, streaks | ✅ | |

## Reminders

| Feature | Status | Notes |
| --- | --- | --- |
| Local exact-alarm reminders | ✅ | Timezone/DST-safe via IANA zones |
| Pre-reminders, missed-dose follow-ups | ✅ | Per-profile minutes |
| Quiet hours & daily summary | ✅ | Applied at schedule time |
| Notification privacy levels | ✅ | Hide medicine names on lock screen |
| Actionable notifications (take/skip) | 🧪 | Wired via action dispatcher; verify on device |
| Boot / timezone-change rescheduling | 🧪 | Receivers declared; verify on device |
| Travel mode (reminders stay on your home time zone) | ✅ | Per person. Toggle in Profile → Time zone, or from the Home banner when the phone changes zone. Home shows both clocks and each dose shows "your time" |
| Choose any IANA time zone for your schedule | ✅ | Searchable picker; changing it rebuilds reminders at once |
| Push notifications (FCM) | 🔌 | Firebase wired behind feature detection; activates when `google-services.json` is added (see docs/FIREBASE.md) |

## Inventory

| Feature | Status | Notes |
| --- | --- | --- |
| Stock tracking per medicine | ✅ | Auto-deduct on take |
| Refill & manual adjustment | ✅ | Full audit trail |
| Low-stock thresholds & alerts | ✅ | Chip + dedicated indicators |
| Refill-date projection | ✅ | From the real upcoming-dose calendar |
| Unit safety (mL vs tablet etc.) | ✅ | Mismatched/fractional deductions refused |

## Medicine information

| Feature | Status | Notes |
| --- | --- | --- |
| Drug label lookup (INN/generic-first) | 🔌 openFDA | Works for Indian medicines via the generic name on the strip; key-less free tier |
| Source attribution on clinical text | ✅ | Never presented as advice |
| Interaction checker / dosing engine | ❌ | Safety boundary — never computed |

## Privacy & security

| Feature | Status | Notes |
| --- | --- | --- |
| 100% offline, no accounts | ✅ | No telemetry, no analytics SDKs |
| Biometric app lock | 🧪 | `local_auth`; verify on device |
| Secure storage for secrets | ✅ | `flutter_secure_storage` |
| Cloud sync / multi-device | 🔌 | Optional, off until switched on; a per-person sync code links a phone and the web |

## Input helpers

| Feature | Status | Notes |
| --- | --- | --- |
| Barcode scan to fill medicine name | 🧪 | `mobile_scanner`; manual fallback always offered |
| Medicine photo | 🧪 | `image_picker` |
| Several people on one device | ✅ | Each person has their own database, reminders and sync code; switch from Home or Profile |
| Assistant answers questions about your medicines | 🔌 | "What do I take tonight?", "how many tablets are left?" — answered from your own schedule, stock and recent doses; never medical advice |
| Remove cancelled doses from the calendar | ✅ | Cancelled doses are not counted; remove one or a whole day |

---

### Summary

- **Everything that affects medical correctness is ✅ and test-covered.**
  Scheduling, validation, status windows, adherence math, and stock accounting
  are pure, unit-tested domain logic.
- **🧪 items are implemented** but depend on hardware/OS behaviour that CI
  cannot verify (alarms firing, camera, biometrics).
- **🔌 items are optional integrations** behind provider/repository seams;
  the app is complete without them.
- **❌ items are deliberate exclusions**, mostly for medical-safety or privacy
  reasons — not missing work.
