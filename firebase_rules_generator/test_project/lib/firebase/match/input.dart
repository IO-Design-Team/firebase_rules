// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestorePath, FirestoreResource>(
    rules: (path, request, resource) => [
      Allow([Operation.read, Operation.write], request.auth != null)
    ],
    matches: (path, request, resource) => [
      Match<TestPath, FirestoreResource<TestResource>>(
        rules: (path, request, resource) => [
          Allow([Operation.read], path.id == 'asdf'),
        ],
      ),
    ],
  ),
];

abstract class TestResource {
  int get asdf;
}

abstract class TestPath extends FirebasePath {
  String get id;

  @override
  String get path => '/test/$id';
}
