import 'dart:typed_data';

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_rules/src/namespace/model/model.dart';

/// Access to [RulesBytes] methods
extension RulesBytesExtension on Uint8List {
  /// Access to [RulesBytes] methods
  RulesBytes get rules => throw UnimplementedError();
}

/// Access to [RulesLatLng] methods
extension RulesLatLngExtension on GeoPoint {
  /// Access to [RulesLatLng] methods
  RulesLatLng get rules => throw UnimplementedError();
}

/// Access to [RulesList] methods
extension RulesListExtension<T> on List<T> {
  /// Access to [RulesList] methods
  RulesList<T> get rules => throw UnimplementedError();
}

/// Access to [RulesMap] methods
extension RulesMapExtension<K, V> on Map<K, V> {
  /// Access to [RulesMap] methods
  RulesMap<K, V> get rules => throw UnimplementedError();
}

/// Access to [RulesSet] methods
extension RulesSetExtension<T> on Set<T> {
  /// Access to [RulesSet] methods
  RulesSet<T> get rules => throw UnimplementedError();
}

/// Access to [RulesString] methods
extension RulesStringExtension on String {
  /// Access to [RulesString] methods
  RulesString get rules => throw UnimplementedError();
}

/// Access to [RulesTimestamp] methods
extension RulesTimestampExtension on Timestamp {
  /// Access to [RulesTimestamp] methods
  RulesTimestamp get rules => throw UnimplementedError();
}
