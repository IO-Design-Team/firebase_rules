import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    // Invalid number of wildcards
    // expect_lint: invalid_match_path
    '/{too}/{many}',
    matches: (too, request, resource) => [],
  ),
];
