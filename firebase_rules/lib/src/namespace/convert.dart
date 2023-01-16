import 'dart:typed_data';

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_rules/src/namespace/model/bytes.dart';
import 'package:firebase_rules/src/namespace/model/lat_lng.dart';
import 'package:firebase_rules/src/namespace/model/list.dart' as list;
import 'package:firebase_rules/src/namespace/model/map.dart' as map;
import 'package:firebase_rules/src/namespace/model/set.dart' as rules_set;
import 'package:firebase_rules/src/namespace/model/string.dart' as string;
import 'package:firebase_rules/src/namespace/model/timestamp.dart' as timestamp;

/// Access to [Bytes] methods
extension BytesExtension on Uint8List {
  /// Access to [Bytes] methods
  Bytes get rulesType => throw UnimplementedError();
}

/// Access to [LatLng] methods
extension LatLngExtension on GeoPoint {
  /// Access to [LatLng] methods
  LatLng get rulesType => throw UnimplementedError();
}

/// Access to [list.List] methods
extension ListExtension<T> on List<T> {
  /// Access to [list.List] methods
  list.List<T> get rulesType => throw UnimplementedError();
}

/// Access to [map.Map] methods
extension MapExtension<K, V> on Map<K, V> {
  /// Access to [map.Map] methods
  map.Map<K, V> get rulesType => throw UnimplementedError();
}

/// Access to [rules_set.Set] methods
extension SetExtension<T> on Set<T> {
  /// Access to [rules_set.Set] methods
  rules_set.Set<T> get rulesType => throw UnimplementedError();
}

/// Access to [string.String] methods
extension StringExtension on String {
  /// Access to [string.String] methods
  string.String get rulesType => throw UnimplementedError();
}

/// Access to [timestamp.Timestamp] methods
extension TimestampExtension on Timestamp {
  /// Access to [timestamp.Timestamp] methods
  timestamp.Timestamp get rulesType => throw UnimplementedError();
}
