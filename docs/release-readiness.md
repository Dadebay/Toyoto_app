# BMW Connect release readiness

## Scope and current state

- Repository branch at start: `main` (`71a7d18`), clean; no open pull requests, workflows, tags, or GitHub Releases.
- Flutter/Dart: 3.47.8 / 3.13.7. Source version: `1.0.0+1`.
- Android and iOS are present. There is no production API, authentication, payment integration, vehicle connection, or data persistence in the source. Most screens read `MockData` or mutate in-memory `AppState`.
- The repository name and native package identifiers still reflect the original Toyota concept, while the UI and data have been rebranded to BMW Connect.
- No official project website, app store listing, signing certificate, or brand authorization is verified for this repository.

## Changes and checks

- The app now identifies itself as a demo across routes. Checkout preview leaves the cart intact and never claims to submit an order or earn purchase points. SOS, dealer, booking, and digital key copy no longer claims that a real service or vehicle was contacted.
- An inventory found 37 literal asset references; only the six `.glb` references are missing. Missing 3D model files show a visible fallback. `assets/models/` is retained for optional licensed local models, and `.glb` files remain ignored.
- Android release no longer uses the debug signing key. Signing is opt-in through ignored `android/key.properties`.
- The unused `cupertino_icons` package was removed. Package lockfile refreshed for the current Flutter SDK.
- CI runs locked dependencies, formatting, analyzer, widget tests, an unsigned Android release build, and an unsigned iOS release build.
- Local checks on Flutter 3.47.8: locked `pub get` passed, `dart format` passed (56 files, zero pending changes), `flutter analyze` found zero issues, and both widget tests passed.
- The local Android JDK 17 Gradle release task passed and produced an 81 MB unsigned APK. `aapt` found package `com.toyotatm.toyota_tm_app`, version `1.0.0` (code `1`); `apksigner verify` rejected it as unsigned, as intended. Flutter's local default JDK 25 cannot run this Gradle 8.14.3 build; CI explicitly selects JDK 17.
- `flutter build ios --no-codesign --release --no-pub` passed and produced a 47.4 MB `Runner.app`. The current Flutter tool migrated the iOS deployment target from 13 to 15 and added Swift Package Manager plugin integration.
- The iOS project still carries CocoaPods integration after the Swift Package Manager migration. Flutter reported it as a build-time cleanup opportunity; it did not block the unsigned build. Flutter also warned that current Gradle, Android Gradle Plugin, and Kotlin versions will need a future coordinated upgrade.

## Distribution blockers

1. This is a prototype. Real dealer, vehicle, order, emergency, and payment integrations require an owned backend, API contracts, security review, and end-to-end tests before customer use.
2. The six referenced 3D `.glb` models are not in Git; license and supply them for a full visual release. Product images and brand assets also need a redistribution rights review.
3. Confirm the product owner may use the BMW brand, official dealer names, phone numbers, and sample vehicle identities before public distribution.
   The tracked Android launcher icon is still the Flutter template icon; replace and review platform icons before a store submission.
4. Confirm final Android application ID and iOS bundle ID, then set version/build numbers for the first store submission. Changing an existing store identifier requires a separate app listing.
5. Obtain and verify the project's own Android release signing certificate and iOS provisioning. No signed APK, App Store archive, or store listing has been verified.
6. Smoke-test startup, navigation, missing-model fallback, and native plugins on physical Android and iOS devices. No device was attached during this review.
7. Android currently permits cleartext traffic because `model_viewer_plus` serves bundled models through a loopback HTTP proxy. Before production, restrict this permission to the needed local origin and verify 3D rendering on a device; no external HTTP endpoint was found in the app source.

Do not tag or publish a binary GitHub Release until these blockers are resolved. If Android direct download is intended, compare its certificate against Play Console's **app signing** certificate when applicable, verify package/version/signature and SHA-256, install the APK on a real device, and only then attach it to the exact source tag. A Play upload key alone does not prove it can upgrade a Play-installed APK.

## Operations

There is no backend or database to deploy, back up, or rotate in this repository. Store signing keys and any future service credentials outside Git. The project owner must document service owners, recovery contacts, and rollback instructions when production integrations are added.
