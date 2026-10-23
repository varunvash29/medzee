# Firebase setup (optional)

Medzee builds and runs **without** Firebase. When you add your own Firebase
project, two optional capabilities activate automatically:

- **FCM push channel** (`firebase_messaging`) — remote notifications. Note:
  dose reminders are *local exact alarms* by design (precise, private, work
  offline). FCM is the channel for *future* features like caregiver alerts or
  sync nudges, not for reminders themselves.
- **Anonymous auth** (`firebase_auth`) — a stable per-install user id, the seam
  a future caregiver/sync feature would hang identity off.

The integration is feature-detected: **if `google-services.json` is absent,
the build succeeds and every Firebase code path reports itself unavailable.**

---

## 1. Create the Firebase project

1. Go to <https://console.firebase.google.com> and sign in with your Google
   account.
2. **Create project** → name it (e.g. `medzee`). Google Analytics is optional.
3. In the project, click the **Android** icon to add an app:
   - **Package name:** `com.medzee.medzee`
   - **App nickname:** Medzee (anything)
   - **Debug signing certificate SHA-1:** required only for Auth dynamic links
     and Google Sign-In — skip for anonymous auth. To add it later:
     `cd android && ./gradlew signingReport`.
4. Download **`google-services.json`** and place it at:

   ```
   android/app/google-services.json
   ```

   This file is git-ignored (it identifies your project; treat it as
   machine-local configuration, not source code).
5. In the Firebase console, enable **Authentication → Sign-in method →
   Anonymous** if you want the auth seam active.

## 2. Build

```bash
flutter clean
flutter pub get
flutter build apk --debug
```

The Gradle plugin `com.google.gms.google-services` is applied **only when the
file exists** (see `android/app/build.gradle.kts`), so removing the file
returns the app to its fully offline build.

## 3. iOS (when needed)

Add an iOS app in the same Firebase project, download
`GoogleService-Info.plist`, and add it to `ios/Runner/` via Xcode
(File → Add Files to "Runner", target membership: Runner).

## 4. Verifying

- On launch, the app attempts `Firebase.initializeApp()` inside a guard. With
  a valid `google-services.json` and granted notification permission, the FCM
  foreground listener is wired; without it, the log line says Firebase is
  unavailable and startup continues normally. (The registration token is
  fetched only when a server-side feature actually needs it.)
- Foreground FCM messages whose `data.payload` is an app route (e.g.
  `/medicines/<id>`) navigate through the same
  `NotificationActionDispatcher` used by local notification taps.

## 5. What Firebase is *not* used for

- **Reminders.** Local exact alarms are the correct mechanism (precise to the
  minute, no network, no server visibility into your schedule).
- **Clinical data.** Nothing about your medicines, doses or history ever leaves
  the device through Firebase in v1.
- **Crashlytics/Analytics.** Not integrated — no telemetry by design.
