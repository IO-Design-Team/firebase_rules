import 'package:firebase_rules/src/firebase/namespace/model/model.dart';

/// Directory-like pattern for the location of a resource.
abstract class RulesPath {
  /// Index operator
  RulesString operator [](dynamic value);

  /// Bind key-value pairs in a map to a path.
  RulesString bind(RulesMap<String, dynamic> map);
}
