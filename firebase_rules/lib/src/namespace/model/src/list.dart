import 'package:firebase_rules/src/namespace/model/model.dart';

/// List type. Items are not necessarily homogenous.
abstract class RulesList<T> {
  RulesList._();

  /// Index operator, get value index i
  T operator [](int i);

  /// Range operator, get sublist from index i to j
  ///
  /// Translates to `x[i:j]`
  RulesList<T> range(int i, int j);

  /// Check if value v exists in list x.
  ///
  /// Translates to `v in x`
  bool contains(T value);

  /// Create a new list by adding the elements of another list to the end of
  /// this list.
  RulesList<T> concat(RulesList<T> other);

  /// Determine whether the list contains all elements in another list.
  bool hasAll(RulesList<T> other);

  /// Determine whether the list contains any element in another list.
  bool hasAny(RulesList<T> other);

  /// Determine whether all elements in the list are present in another list.
  bool hasOnly(RulesList<T> other);

  /// Join the elements in the list into a string, with a separator.
  RulesString join(RulesString separator);

  /// Create a new list by removing the elements of another list from this list.
  RulesList<T> removeAll(RulesList<T> other);

  /// Get the number of values in the list.
  int size();

  /// Returns a set containing all unique elements in the list.
  ///
  /// In case that two or more elements are equal but non-identical, the result
  /// set will only contain the first element in the list. The remaining
  /// elements are discarded.
  RulesSet<T> toSet();
}
