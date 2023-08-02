import 'package:firebase_rules/src/firebase/namespace/model/src/iterable.dart';

/// A set is an unordered collection. A set cannot contain duplicate items.
abstract class RulesSet<T> extends RulesIterable<T> {
  RulesSet._();

  /// Check if value v exists in set x.
  bool contains(T value);

  /// Returns a set that is the difference between the set calling difference()
  /// and the set passed to difference(). That is, returns a set containing the
  /// elements in the comparison set that are not in the specified set.
  ///
  /// If the sets are identical, returns an empty set (size() == 0).
  RulesSet<T> difference(RulesSet<T> other);

  /// Test whether the set calling hasAll() contains all of the items in the
  /// comparison set passed to hasAll().
  bool hasAll(RulesIterable<T> other);

  /// Test whether the set calling hasAny() contains any of the items in the set
  /// or list passed to hasAny().
  bool hasAny(RulesIterable<T> other);

  /// Test whether the set calling hasOnly() contains only the items in the
  /// comparison set or list passed to hasOnly().
  bool hasOnly(RulesIterable<T> other);

  /// Returns a set that is the intersection between the set calling
  /// intersection() and the set passed to intersection(). That is, returns a
  /// set containing the elements the sets have in common.
  ///
  /// If the sets have no elements in common, returns an empty set
  /// (size() == 0).
  RulesSet<T> intersection(RulesSet<T> other);

  /// Returns the size of the set.
  int size();

  /// Returns a set that is the union of the set calling union() and the set
  /// passed to union(). That is, returns a set that contains all elements from
  /// both sets.
  RulesSet<T> union(RulesSet<T> other);
}
