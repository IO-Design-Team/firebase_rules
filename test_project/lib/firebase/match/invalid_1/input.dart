import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    // Invalid wildcard parameter (should be `database`)
    matches: (_, request, resource) => [],
  ),
];
