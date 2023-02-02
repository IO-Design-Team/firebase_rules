// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test(FirestoreResource resource) {
  final a =
      rules.debug(rules.debug(resource.id) == rules.debug('test'.rules()));
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreRoot, FirestoreResource>(functions: [test]),
];
