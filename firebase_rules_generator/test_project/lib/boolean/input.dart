// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase_rules.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

@RulesFunction()
bool test() {
  final a = rules.parseBool('true'.rules);
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = <Match>[];

abstract class BlobTest {
  Blob get blob;
}
