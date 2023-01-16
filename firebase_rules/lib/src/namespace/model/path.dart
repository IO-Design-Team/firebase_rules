import 'package:firebase_rules/src/rules_type.dart';

/// Directory-like pattern for the location of a resource.
abstract class Path extends RulesType {
  /// Index operator
  String operator [](dynamic value);

  /// Bind key-value pairs in a map to a path.
  String bind(Map<String, dynamic> map);
}
