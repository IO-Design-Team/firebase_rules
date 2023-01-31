import 'package:firebase_rules/firebase.dart';
import 'paths.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestorePath, FirestoreResource>(
    matches: (path, request, resource) => [
      Match<UsersPath, FirestoreResource<User>>(
        rules: (usersPath, request, resource) => [
          Allow([Operation.read], resource.data.userId == usersPath.userId)
        ],
      ),
    ],
  ),
];
