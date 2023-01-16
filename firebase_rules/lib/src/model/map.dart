import 'dart:core' as core;

import 'package:firebase_rules/src/model/list.dart';
import 'package:firebase_rules/src/model/set.dart';
import 'package:firebase_rules/src/rules_type.dart';

/// Map type, used for simple key-value mappings.
abstract class Map<K, V> extends RulesType {
  Map._();

  /// Index operator, get value at key name k
  V? operator [](K k) => throw core.UnimplementedError();

  /// Check if key k exists in map x
  ///
  /// Translates to `k in x`
  core.bool containsKey(K key) => throw core.UnimplementedError();

  /// Return a rules.MapDiff representing the result of comparing the current
  /// Map to a comparison Map.
  MapDiff<K, V> diff(Map<K, V> other) => throw core.UnimplementedError();

  /// Returns the value associated with a given search key string.
  ///
  /// For nested Maps, involving keys and sub-keys, returns the value associated
  /// with a given sub-key string. The sub-key is identified using a list, the
  /// first item of which is a top-level key and the last item the sub-key whose
  /// value is to be looked up and returned. See the nested Map example below.
  ///
  /// The function requires a default value to return if no match to the given
  /// search key is found.
  V get(core.Object key, V defaultValue);

  /// Get the list of keys in the map.
  List<K> keys();

  /// Get the number of entries in the map.
  core.int size();

  /// Get the list of values in the map.
  List<V> values();
}

/// The MapDiff type represents the result of comparing two rules.Map objects.
abstract class MapDiff<K, V> extends RulesType {
  MapDiff._();

  /// Returns a rules.Set, which lists any keys that the Map calling diff()
  /// contains that the Map passed to diff() does not.
  Set<K> addedKeys();

  /// Returns a rules.Set, which lists any keys that have been added to,
  /// removed from or modified from the Map calling diff() compared to the Map
  /// passed to diff(). This function returns the set equivalent to the combined
  /// results of MapDiff.addedKeys(), MapDiff.removedKeys() and
  /// MapDiff.changedKeys().
  Set<K> affectedKeys();

  /// Returns a rules.Set, which lists any keys that appear in both the Map
  /// calling diff() and the Map passed to diff(), but whose values are not
  /// equal.
  Set<K> changedKeys();

  /// Returns a rules.Set, which lists any keys that the Map calling diff()
  /// does not contain compared to the Map passed to diff().
  Set<K> removedKeys();

  /// Returns a rules.Set, which lists any keys that appear in both the Map
  /// calling diff() and the Map passed to diff(), and whose values are equal.
  Set<K> unchangedKeys();
}

/// Access to [Map] methods
extension MapExtension<K, V> on core.Map<K, V> {
  /// Access to [Map] methods
  Map<K, V> get rulesType => throw core.UnimplementedError();
}
