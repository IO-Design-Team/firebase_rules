import 'package:firebase_rules/firebase.dart';
import 'paths.dart';

/// Match parameter functions can be split out for organization. However, these
/// must be declared in the same file. Note that match functions cannot contain
/// a body.
List<Match> detached(
  FirestoreRoot root,
  RulesRequest<FirestoreResource> request,
  FirestoreResource resource,
) =>
    [
      Match<UsersPath, FirestoreResource<User>>(
        rules: (usersPath, request, resource) => [
          Allow([Operation.read], resource.data.userId == usersPath.userId)
        ],
      ),
    ];

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreRoot, FirestoreResource>(matches: detached),
];
