# ileum

A new Flutter project.

## Shorebird OTA

This project is prepared for Shorebird over-the-air updates. The setup expects a
checked-in `shorebird.yaml` at the project root, and the file is bundled as an
asset so the updater can read the app ID at runtime.

To finish enabling Shorebird on a machine where the CLI is allowed to run:

1. Run `shorebird init` from the project root to generate the real `app_id`.
2. Build and publish the first release with `shorebird release android`.
3. Ship Dart-only fixes with `shorebird patch android`.

The Android manifest already includes internet access, which Shorebird needs to
download patches.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
