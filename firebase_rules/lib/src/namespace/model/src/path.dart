import 'package:firebase_rules/src/namespace/model/model.dart';
import 'package:firebase_rules/src/rules_type.dart';

/// Directory-like pattern for the location of a resource.
abstract class RulesPath extends RulesType {
  /// Index operator
  RulesString operator [](dynamic value);

  /// Bind key-value pairs in a map to a path.
  RulesString bind(RulesMap<String, dynamic> map);
}
