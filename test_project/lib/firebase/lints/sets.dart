import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    rules: (database, request, resource) {
      return [
        // expect_lint: no_set_literals
        Allow([Operation.read], {1, 2, 3}.rules().contains(1)),
      ];
    },
  ),
];
