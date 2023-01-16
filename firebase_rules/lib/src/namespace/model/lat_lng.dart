import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_rules/src/rules_type.dart';

/// Type representing a geopoint. Used in rules as latlng.
abstract class LatLng extends RulesType {
  /// Calculate distance between two LatLng points in distance (meters).
  double distance(GeoPoint other);

  /// Get the latitude value in the range [-90.0, 90.0].
  double latitude();

  /// Get the longitude value in the range [-180.0, 180.0].
  double longitude();
}
