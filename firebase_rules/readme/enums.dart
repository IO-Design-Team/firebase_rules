import 'package:firebase_rules/firebase.dart';

@FirebaseRules(
  service: Service.firestore,

  /// Pass in enum conversion maps for all enums you plan to use in these rules
  enums: [Test.map],
)
final firestoreRules = [
  Match<FirestoreRoot, FirestoreResource>(
    matches: (path, request, resource) => [
      Match<TestPath, FirestoreResource<TestResource>>(
        rules: (path, request, resource) => [
          Allow([Operation.read], resource.data.test == Test.a),
        ],
      ),
    ],
  ),
];

abstract class TestPath extends FirebasePath {
  @override
  String get path => '/test';
}

enum Test {
  a,
  b,
  c;

  static const map = {
    Test.a: 'a',
    Test.b: 'b',
    Test.c: 'c',
  };
}

abstract class TestResource {
  Test get test;
}
