# BMW Connect prototype

BMW Connect is a Flutter vehicle companion **prototype** with a showroom, vehicle dashboard, roadside assistance preview, service booking preview, spare parts catalog, and English, Turkmen, and Russian UI. The repository was renamed in the app from its earlier Toyota concept; the GitHub repository name remains `Toyoto_app`.

**This app does not connect to a vehicle, dealer, emergency service, or payment provider.** Vehicle details, dealers, orders, prices, and notifications are sample data. The on-screen demo notice stays visible while using the app. Do not rely on its SOS preview for real assistance.

## Requirements and setup

- Flutter 3.47.8 (Dart 3.13.7)
- Android: JDK 17 and the Android SDK
- iOS: macOS, Xcode, and CocoaPods

If Flutter selects an incompatible newer JDK, run `flutter config --jdk-dir=/path/to/jdk17` before the Android build. The iOS deployment target is 15.0.

```sh
flutter pub get --enforce-lockfile
flutter run
```

Run the checks:

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
```

The 3D vehicle models are not distributed in this repository. The app displays an explicit fallback if a model is absent. To try the 3D viewer, place licensed `.glb` files named `bmw_m5.glb`, `bmw_m8.glb`, `bmw_m340i.glb`, `bmw_m4.glb`, `bmw_xb7.glb`, and `bmw_x6m.glb` in `assets/models/`. These files are ignored by Git; verify redistribution rights before packaging them.

## Builds

```sh
flutter build apk --release
flutter build ios --release --no-codesign
```

The default Android release build is **unsigned**. To sign a local build, copy `android/key.properties.example` to the ignored `android/key.properties` and supply your own keystore path and credentials. Never commit either the real properties or a keystore. iOS distribution requires an Apple team and provisioning profile.

The current source version is `1.0.0+1`. Android application ID: `com.toyotatm.toyota_tm_app`; iOS bundle ID: `com.toyotatm.toyotaTmApp`. These legacy identifiers should be reviewed before any new store submission. No verified Google Play, App Store, website, or GitHub binary release exists for this prototype, so this README does not link to one.

See [release readiness](docs/release-readiness.md) for the build evidence and distribution blockers.
