# Known limitations

A living list of what Medzee v1 does **not** do yet, and honest caveats about
what it does. Also see "not integrated by design" in
[EXTERNAL_SERVICES.md](EXTERNAL_SERVICES.md) — those are boundaries, not gaps.

---

## Platform coverage

- **iOS is compile-clean but unverified on device.** Usage descriptions
  (camera, photo library, Face ID) are present in `Info.plist`, and
  `flutter_local_notifications` supports iOS scheduling, but the exact-alarm
  and notification flows have only been exercised on Android. Verify reminder
  delivery, quiet hours, and the app lock on a physical iPhone before shipping.
- **Exact alarms on Android 12+** require the user to grant
  "Alarms & reminders". Medzee detects a missing grant and surfaces it in
  Settings; there is no way for the app to grant it programmatically (platform
  restriction, not a bug).

## Device features

- **Barcode scanning and medicine photos** are implemented with
  `mobile_scanner` and `image_picker` and degrade gracefully (manual entry),
  but camera behaviour is best verified on real hardware; emulator cameras are
  unreliable for barcode testing.
- **Biometric app lock** (`local_auth`) follows the platform's enrolled-biometric
  state. Devices without enrolled biometrics see the toggle disabled with an
  explanation rather than a failure.

## Product scope

- **Single local profile.** The schema and repository contracts are
  profile-ready, but the UI manages one profile. Multiple users on one device
  (e.g. a shared tablet in a care setting) is a schema-compatible addition,
  not yet built.
- **Insights are on-screen only.** No PDF/CSV export of adherence reports yet.
- **Medicine-info coverage is INN/generic-based.** Lookups work correctly for
  any medicine searched by its INN generic name (the name Indian law requires
  on every strip). Indian *brand* names (e.g. Dolo, Crocin) are not in the
  openFDA database; the UI steers users to the generic name and shows "no
  label information found" rather than guessing. No free India-specific public
  API exists to plug in instead.
- **No cloud sync / multi-device.** All data lives on-device in SQLite.
  Uninstalling deletes it (standard platform behaviour).

## Testing caveats

- The full unit/widget suite (125 tests) runs in CI-friendly conditions.
  Integration tests (`integration_test/`) require a device or emulator and are
  not part of `flutter test`.
- Notification timing under extreme device conditions (manufacturer battery
  savers, aggressive task killers) is a platform reality the app mitigates —
  via exact alarms, boot receivers, and timezone-change rescheduling — but
  cannot eliminate.
