// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    rules: (database, request, resource) => [
      Allow([Operation.read, Operation.write], request.auth != null),
    ],
    matches: (database, request, resource) => [
      Match<FirestoreResource<TestResource>>(
        '/test/{id}',
        rules: (id, request, resource) => [
          Allow(
            [Operation.read],
            id == 'asdf'.rules() && resource.data.asdf == 123,
          ),
        ],
      ),
    ],
  ),
];

abstract class TestResource {
  int get asdf;
}
