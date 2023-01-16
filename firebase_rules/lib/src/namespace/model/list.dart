import 'dart:core' as core;

import 'package:firebase_rules/src/namespace/model/set.dart';
import 'package:firebase_rules/src/rules_type.dart';

/// List type. Items are not necessarily homogenous.
abstract class List<T> extends RulesType {
  List._();

  /// Index operator, get value index i
  T operator [](core.int i);

  /// Range operator, get sublist from index i to j
  ///
  /// Translates to `x[i:j]`
  List<T> range(core.int i, core.int j);

  /// Check if value v exists in list x.
  ///
  /// Translates to `v in x`
  core.bool contains(T value);

  /// Create a new list by adding the elements of another list to the end of
  /// this list.
  List<T> concat(List<T> other);

  /// Determine whether the list contains all elements in another list.
  core.bool hasAll(List<T> other);

  /// Determine whether the list contains any element in another list.
  core.bool hasAny(List<T> other);

  /// Determine whether all elements in the list are present in another list.
  core.bool hasOnly(List<T> other);

  /// Join the elements in the list into a string, with a separator.
  core.String join(core.String separator);

  /// Create a new list by removing the elements of another list from this list.
  List<T> removeAll(List<T> other);

  /// Get the number of values in the list.
  core.int size();

  /// Returns a set containing all unique elements in the list.
  ///
  /// In case that two or more elements are equal but non-identical, the result
  /// set will only contain the first element in the list. The remaining
  /// elements are discarded.
  Set<T> toSet();
}

