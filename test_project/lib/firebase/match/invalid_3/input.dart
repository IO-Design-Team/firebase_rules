import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    // Invalid request parameter
    // expect_lint: invalid_match_function
    rules: (database, asdf, resource) => [],
  ),
];
