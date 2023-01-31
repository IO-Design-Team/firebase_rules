import 'package:firebase_rules/firebase.dart';

void example() {
  /// Dart objects can be converted to rules objects by calling `rules` on them
  ''.rules.range(0, 1);

  /// Methods called on `rules` types also take `rules` types as arguments
  [].rules.concat([].rules);

  /// Types from `cloud_firestore_platform_interface` can also be converted
  /// with the `firebase_rules_convert` package
  /// ex: `Blob`, `GeoPoint`, `Timestamp`
}
