# AI Flutter Test: Calculator

A simple Flutter calculator (number field, `+ − × ÷`, result button), built with
AI assistance as a demo for "AI-assisted smartphone app creation for non-coders".

The app comes with 7 interchangeable visual designs and a browser gallery to
compare them side by side.

## Run

```sh
flutter pub get
flutter run                      # pick a device: Android phone/emulator, Chrome, Windows
```

The active design is set in `lib/main.dart` (`activeDesignId`). The available
designs are `classic`, `midnight`, `lcd`, `neon`, `paper`, `brutal` and `soft`,
all defined in `lib/designs.dart`.

Design gallery in the browser (every preview is the live app):

```sh
flutter run -d chrome --dart-define=GALLERY=true
```

## Tests

```sh
flutter test                                   # logic + widget tests (incl. every design)
flutter test integration_test -d emulator-5554 # end-to-end on an Android emulator/device
```

## Project layout

| Path | Content |
|---|---|
| `lib/calculator.dart` | Calculation logic (no UI) |
| `lib/calculator_view.dart` | The calculator screen, drawn in a given design |
| `lib/designs.dart` | The visual designs |
| `lib/gallery.dart` | Side-by-side design gallery |
| `test/` | Unit and widget tests |
| `integration_test/` | End-to-end tests on a real device/emulator |

## CI

GitHub Actions (`.github/workflows/build-apk.yml`) analyzes, tests and builds a
release APK on every push to `main`. Download it from the run's **Artifacts**
section (`calculator-demo-apk`). The APK is signed with a debug key, so it is
for testing only, not for the Play Store.
