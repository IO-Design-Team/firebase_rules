import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    // Invalid response parameter
    // expect_lint: invalid_match_function
    rules: (database, request, asdf) => [],
  ),
];
