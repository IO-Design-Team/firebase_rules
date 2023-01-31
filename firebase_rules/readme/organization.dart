import 'package:firebase_rules/firebase.dart';
import 'paths.dart';

/// Match parameter functions can be split out for organization. These functions
/// can be in any file in the project. Note that match functions cannot contain
/// a body.
List<Match> detached(path, request, resource) => [
      Match<UsersPath, FirestoreResource<User>>(
        rules: (usersPath, request, resource) => [
          Allow([Operation.read], resource.data.userId == usersPath.userId)
        ],
      ),
    ];

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestorePath, FirestoreResource>(matches: detached),
];
