import 'package:firebase_rules/firebase.dart';

@FirebaseRules(
  service: Service.firestore,

  /// Pass in enum conversion maps for all enums you plan to use in these rules
  enums: [Test.map],
)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    matches: (path, request, resource) => [
      Match<FirestoreResource<TestResource>>(
        '/test',
        rules: (path, request, resource) => [
          Allow([Operation.read], resource.data.test == Test.a),
        ],
      ),
    ],
  ),
];

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
