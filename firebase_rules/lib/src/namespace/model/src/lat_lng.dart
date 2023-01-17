import 'package:firebase_rules/src/rules_type.dart';

/// Type representing a geopoint. Used in rules as latlng.
abstract class RulesLatLng extends RulesType {
  /// Calculate distance between two LatLng points in distance (meters).
  double distance(RulesLatLng other);

  /// Get the latitude value in the range [-90.0, 90.0].
  double latitude();

  /// Get the longitude value in the range [-180.0, 180.0].
  double longitude();
}
