import 'dart:core' as core;

import 'package:firebase_rules/src/rules_type.dart';

/// A set is an unordered collection. A set cannot contain duplicate items.
abstract class Set<T> extends RulesType {
  Set._();

  /// Check if value v exists in set x.
  core.bool contains(T value);

  /// Returns a set that is the difference between the set calling difference()
  /// and the set passed to difference(). That is, returns a set containing the
  /// elements in the comparison set that are not in the specified set.
  ///
  /// If the sets are identical, returns an empty set (size() == 0).
  Set<T> difference(Set<T> other);

  /// Test whether the set calling hasAll() contains all of the items in the
  /// comparison set passed to hasAll().
  core.bool hasAll(Set<T> other);

  /// Test whether the set calling hasAny() contains any of the items in the set
  /// or list passed to hasAny().
  core.bool hasAny(Set<T> other);

  /// Test whether the set calling hasOnly() contains only the items in the
  /// comparison set or list passed to hasOnly().
  core.bool hasOnly(Set<T> other);

  /// Returns a set that is the intersection between the set calling
  /// intersection() and the set passed to intersection(). That is, returns a
  /// set containing the elements the sets have in common.
  ///
  /// If the sets have no elements in common, returns an empty set
  /// (size() == 0).
  Set<T> intersection(Set<T> other);

  /// Returns the size of the set.
  core.int size();

  /// Returns a set that is the union of the set calling union() and the set
  /// passed to union(). That is, returns a set that contains all elements from
  /// both sets.
  Set<T> union(Set<T> other);
}

