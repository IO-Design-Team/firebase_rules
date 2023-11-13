import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    // Invalid wildcard parameter (should be `database`)
    // expect_lint: invalid_match_function
    rules: (asdf, request, resource) => [],
  ),
];
