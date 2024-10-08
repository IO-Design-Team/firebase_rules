// This is a test
// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test() {
  final a = rules.firestore.exists(rules.path(r'/path/to/resource'.rules()));
  final b =
      rules.firestore.existsAfter(rules.path(r'/path/to/resource'.rules()));
  final c = rules.firestore.get(rules.path(r'/path/to/resource'.rules()));
  final d = rules.firestore
      .get<TestResource>(
        rules.path(r'/path/to/resource'.rules(), database: 'default'),
      )
      .data
      .asdf;
  final e = rules.firestore.getAfter(rules.path(r'/path/to/resource'.rules()));
  final f = rules.firestore
      .getAfter<TestResource>(rules.path(r'/path/to/resource'.rules()))
      .data
      .asdf;
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];

@FirebaseRules(
  service: Service.storage,
  functions: [test],
)
final storageRules = [
  Match<StorageResource>(storageRoot),
];

abstract class TestResource {
  int get asdf;
}
