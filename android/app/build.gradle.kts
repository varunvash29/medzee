plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Firebase is optional: the google-services plugin is applied only when the
// project file exists, so builds without it (fully offline) keep working.
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
}

android {
    namespace = "com.medzee.medzee"
    // mobile_scanner pulls androidx.camera 1.6.1, which requires compiling
    // against SDK 36 (targetSdk stays on Flutter's default).
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    // flutter_local_notifications schedules reminders with java.time APIs that
    // only exist natively on API 26+. Core library desugaring backports them
    // so scheduled notifications work on every supported device.
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    defaultConfig {
        applicationId = "com.medzee.medzee"
        // flutter_local_notifications needs API 21+; local_auth /
        // mobile_scanner need API 23+.
        // Firebase (Messaging transitive) requires API 24; make it explicit
        // instead of relying on Flutter's silent auto-raise.
        minSdk = maxOf(flutter.minSdkVersion, 24)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// Kotlin 2.4 removed the legacy `kotlinOptions.jvmTarget` DSL.
kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
    }
}

dependencies {
    // Required by core library desugaring (flutter_local_notifications).
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // Workaround for a known Flutter/Android 12L+ crash when desugaring is
    // enabled: https://issuetracker.google.com/issues/273619236
    implementation("androidx.window:window:1.2.0")
    implementation("androidx.window:window-java:1.2.0")
}

flutter {
    source = "../.."
}
