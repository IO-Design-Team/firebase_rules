// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

part 'input2.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreRoot, FirestoreResource>(
    functions: [isNotAnonymous],
    rules: detachedRules,
    matches: detachedMatches,
  ),
];
