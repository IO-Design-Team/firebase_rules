// This is a test
// ignore_for_file: unused_local_variable

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_convert/firebase_rules_convert.dart';

bool test(FirestoreResource<GeoPointTest> resource, RulesLatLng other) {
  final a = resource.data.geopoint.rules().distance(other);
  final b = resource.data.geopoint.rules().latitude();
  final c = resource.data.geopoint.rules().longitude();
  final d = rules.latlng.value(0, 0);
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];

abstract class GeoPointTest {
  GeoPoint get geopoint;
}
