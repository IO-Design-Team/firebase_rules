import 'package:firebase_rules/src/rules_type.dart';

/// A firebase resource object
abstract class Resource<T> extends RulesType {
  Resource._();

  /// The full document name, as a path.
  String get name;

  /// Map of the document data.
  T get data;

  /// String of the document's key
  String get key;
}
