import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    // Invalid wildcard parameter (should be `database`)
    rules: (asdf, request, resource) => [],
  ),
];
