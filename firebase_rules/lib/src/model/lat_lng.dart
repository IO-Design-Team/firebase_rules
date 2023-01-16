import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

/// GeoPoint methods
extension LatLng on GeoPoint {
  /// Calculate distance between two LatLng points in distance (meters).
  double distance(GeoPoint other) => throw UnimplementedError();

  /// Get the latitude value in the range [-90.0, 90.0].
  double latitude() => throw UnimplementedError();

  /// Get the longitude value in the range [-180.0, 180.0].
  double longitude() => throw UnimplementedError();
}
