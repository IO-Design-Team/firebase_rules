import 'package:firebase_rules/src/firebase/namespace/model/model.dart';

/// Access to [RulesList] methods
extension RulesListExtension<T> on List<T> {
  /// Access to [RulesList] methods
  RulesList<U> rules<U>() => throw UnimplementedError();
}

/// Access to [RulesMap] methods
extension RulesMapExtension<K, V> on Map<K, V> {
  /// Access to [RulesMap] methods
  RulesMap<RK, RV> rules<RK, RV>() => throw UnimplementedError();
}

/// Access to [RulesSet] methods
extension RulesSetExtension<T> on Set<T> {
  /// Access to [RulesSet] methods
  RulesSet<U> rules<U>() => throw UnimplementedError();
}

/// Access to [RulesString] methods
extension RulesStringExtension on String {
  /// Access to [RulesString] methods
  RulesString rules() => throw UnimplementedError();
}

/// Convert any [Object] to a [RulesMap]
extension RulesObjectExtension on Object {
  /// Convert any [Object] to a [RulesMap]
  RulesMap<String, dynamic> rules() => throw UnimplementedError();
}
