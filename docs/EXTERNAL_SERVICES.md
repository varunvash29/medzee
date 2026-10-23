# External services

Medzee is fully functional offline. The integrations below are **optional** and
isolated behind seams so the app never hard-depends on them.

---

## openFDA (drug label reference) — INN-first, India-ready

**What it does.** When the user looks up a medicine, Medzee shows reference
information sourced from the FDA's public drug-label API: generic/active
ingredient names, and label text such as purpose, usage and warnings.

**Why it works for India.** openFDA indexes medicines by their **INN generic
name** — the same international nonproprietary naming that Indian labelling
rules require on every strip (e.g. "Paracetamol" is printed on a Dolo 650
strip). Medzee therefore searches **generic/INN-first, brand second**, and the
add-medicine wizard has a dedicated "active ingredient" field so the generic
name is always captured. Indian *brand* names are not in the FDA database, but
the generic name printed on any Indian strip resolves correctly.

**Why it's safe to enable by default.**

- No API key is required for the free tier (240 requests/day, 240 req/min per
  IP). A key raises that to 120,000/day.
- Requests contain only the search term the user typed — never profile data,
  schedules, or history.
- Everything returned is displayed with explicit source attribution
  ("Source: U.S. FDA drug label") and presented as reference material, never as
  advice. Medzee never invents clinical facts: if the API has no answer, the UI
  says so.

**Honest boundary.** There is no free public India-specific drug-label API
(CDSCO publishes none; pharmacy aggregators' APIs are private). If a credible
Indian formulary API becomes available, it plugs into the same seam (below).

**Where it lives.** `lib/services/medicine_info_service.dart` implements the
`MedicineInfoProvider` contract in
`lib/domain/repositories/medicine_info_repository.dart`. To swap providers,
implement the contract and change one provider line in
`lib/state/providers.dart` — no UI changes needed.

**Configuration.**

```bash
# optional — raises rate limits
flutter run --dart-define=OPENFDA_API_KEY=your_key_here
```

Docs: <https://open.fda.gov/apis/drug/label/>

---

## Firebase (optional add-on — wired behind feature detection)

**Status: SDK shipped, inactive without configuration.** `firebase_core`,
`firebase_messaging` and `firebase_auth` are dependencies, but every Firebase
path is guarded by `FirebaseGateway.tryInitialize()`. Without
`android/app/google-services.json` the gateway reports unavailable, the
google-services Gradle plugin is not applied, and startup stays fully offline.
See `docs/FIREBASE.md` for setup.

| Concern | Existing seam | Notes |
| --- | --- | --- |
| Cloud Messaging (FCM) | `PushService` | All dose reminders remain local exact alarms. FCM is a *remote* channel reserved for future caregiver alerts; foreground `data.payload` routes are dispatched through `NotificationActionDispatcher`, the same path local notification taps use. |
| Auth / accounts | `FirebaseAuthService` | Anonymous sign-in provides a stable per-install uid for future sync scoping. Nothing is called automatically at launch; `ProfileRepository` remains local. |
| Remote config / flags | none (by design) | Medical behaviour must not change remotely; configuration stays on-device. |

**When extending the Firebase integration**, keep these invariants:

1. The core app must remain fully functional with zero network connectivity.
2. Clinical logic (scheduling, validation, stock) never depends on a server
   response.
3. Any sync adapter implements the existing repository contracts rather than
   introducing new write paths.
4. No clinical data is uploaded without explicit, granular user consent.

---

## What is deliberately not integrated

- **Ad networks / analytics SDKs** — none, and none planned.
- **Drug-interaction or dosing engines** — Medzee never computes clinical
  guidance; this is a safety boundary, not a missing feature.
- **Cloud backup** — out of scope for v1; the Drift database is portable
  (single SQLite file) if an export feature is added later.
