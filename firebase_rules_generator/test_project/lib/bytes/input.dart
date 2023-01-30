import 'package:firebase_rules/firebase_rules.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_rules_convert/firebase_rules_convert.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestorePath, FirestoreResource<BlobTest>>(
    rules: (path, request, resource) => [
      Rule(
        [Operation.read],
        rules.parseBytes(''.rules) == resource.data.blob.rules,
      ),
    ],
  ),
];

abstract class BlobTest {
  Blob get blob;
}
