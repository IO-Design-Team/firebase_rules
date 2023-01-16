import 'dart:typed_data';

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_rules/src/namespace/model/model.dart';

/// Access to [Bytes] methods
extension BytesExtension on Uint8List {
  /// Access to [Bytes] methods
  Bytes get rules => throw UnimplementedError();
}

/// Access to [LatLng] methods
extension LatLngExtension on GeoPoint {
  /// Access to [LatLng] methods
  LatLng get rules => throw UnimplementedError();
}

/// Access to [list.RulesList] methods
extension ListExtension<T> on List<T> {
  /// Access to [list.RulesList] methods
  RulesList<T> get rules => throw UnimplementedError();
}

/// Access to [map.RulesMap] methods
extension MapExtension<K, V> on Map<K, V> {
  /// Access to [map.RulesMap] methods
  RulesMap<K, V> get rules => throw UnimplementedError();
}

/// Access to [rules_set.RulesSet] methods
extension SetExtension<T> on Set<T> {
  /// Access to [rules_set.RulesSet] methods
  RulesSet<T> get rules => throw UnimplementedError();
}

/// Access to [string.RulesString] methods
extension StringExtension on String {
  /// Access to [string.RulesString] methods
  RulesString get rules => throw UnimplementedError();
}

/// Access to [timestamp.Timestamp] methods
extension TimestampExtension on Timestamp {
  /// Access to [timestamp.Timestamp] methods
  RulesTimestamp get rules => throw UnimplementedError();
}
