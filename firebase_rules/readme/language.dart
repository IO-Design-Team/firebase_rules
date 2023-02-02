import 'package:firebase_rules/firebase.dart';

void example() {
  /// Dart objects can be converted to rules objects by calling `.rules()` on them
  ''.rules().range(0, 1);

  /// Methods called on `rules` types also take `rules` types as arguments.
  /// Calling `.rules()` on an iterable or map also allows for casting.
  [].rules<RulesString>().concat([].rules());

  /// Global rules functions are available on the `rules` object
  rules.string(true);

  /// Use the `raw` function if type-safe code is impractical.
  /// The `raw` function also allows for casting.
  rules.raw<bool>("foo.bar.baz == 'qux'");

  /// Types from `cloud_firestore_platform_interface` can also be converted
  /// with the `firebase_rules_convert` package
  /// ex: `Blob`, `GeoPoint`, `Timestamp`
}
