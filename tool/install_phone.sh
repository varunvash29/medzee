#!/usr/bin/env bash
# Builds the release APK for 64-bit ARM phones only (about a third of the
# native work of the default build) and installs it over adb.
set -e
flutter build apk --release --target-platform android-arm64
adb install -r build/app/outputs/flutter-apk/app-release.apk
