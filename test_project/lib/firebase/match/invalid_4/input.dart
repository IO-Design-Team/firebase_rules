import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    // Invalid response parameter
    rules: (database, request, asdf) => [],
  ),
];
