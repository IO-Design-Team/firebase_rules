import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    '/other/stuff',
    // Wildcard parameter should be `_`
    // expect_lint: invalid_match_function
    rules: (asdf, request, response) => [],
  ),
];
