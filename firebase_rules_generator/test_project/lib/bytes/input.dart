// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase_rules.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_rules_convert/firebase_rules_convert.dart';

@RulesFunction()
bool test(FirestoreResource<BlobTest> resource) {
  final a = rules.parseBytes(r'\342\202\254'.rules);
  final b = resource.data.blob.rules.size();
  final c = resource.data.blob.rules.toBase64();
  final d = resource.data.blob.rules.toHexString();
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = <Match>[];

abstract class BlobTest {
  Blob get blob;
}
