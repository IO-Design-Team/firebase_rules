import 'package:firebase_rules/firebase.dart';
import 'shared.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    matches: (path, request, resource) => [
      Match<FirestoreResource<User>>(
        '/users/{userId}',
        rules: (userId, request, resource) => [
          Allow([Operation.read], resource.data.userId.rules() == userId),
        ],
      ),
    ],
  ),
];
