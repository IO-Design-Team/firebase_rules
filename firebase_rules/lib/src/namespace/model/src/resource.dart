import 'package:firebase_rules/src/namespace/model/model.dart';

/// A firebase resource object
abstract class RulesResource<T> {
  RulesResource._();

  /// The full document name, as a path.
  RulesString get name;

  /// Map of the document data.
  T get data;

  /// String of the document's key
  RulesString get key;
}
