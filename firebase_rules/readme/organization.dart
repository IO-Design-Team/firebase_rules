import 'package:firebase_rules/firebase.dart';
import 'shared.dart';

/// Match parameter functions can be split out for organization. However, these
/// must be declared in the same file. Note that match functions cannot contain
/// a body.
List<Match> detached(
  RulesString database,
  RulesRequest<FirestoreResource> request,
  FirestoreResource resource,
) =>
    [
      Match<FirestoreResource<User>>(
        '/users/{userId}',
        rules: (userId, request, resource) => [
          Allow([Operation.read], resource.data.userId.rules() == userId)
        ],
      ),
    ];

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot, matches: detached),
];
