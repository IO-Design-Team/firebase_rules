import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    // Invalid number of wildcards
    '/{too}/{many}',
    matches:(too, request, resource) => [],
  ),
];
