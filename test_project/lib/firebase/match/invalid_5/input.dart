import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    '/other/stuff',
    // Wildcard parameter should be `_`
    rules: (asdf, request, response) => [],
  ),
];
