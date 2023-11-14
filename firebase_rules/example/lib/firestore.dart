import 'package:firebase_rules/firebase.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

bool isSignedIn(RulesRequest request) => request.auth != null;

bool isOwner(RulesRequest request, RulesString uid) {
  final requestingUid = request.auth?.uid;
  return requestingUid == uid;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [isSignedIn, isOwner],
)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    rules: (database, request, resource) => [
      Allow([Operation.read], request.auth?.uid == 'god'.rules()),
    ],
    matches: (database, request, resource) => [
      Match<FirestoreResource<User>>(
        '/users/{userId}',
        rules: (userId, request, resource) => [
          Allow([Operation.read], isSignedIn(request)),
          Allow([Operation.create, Operation.update], isOwner(request, userId)),
        ],
      ),
      Match<FirestoreResource<Content>>(
        '/content/{contentId}',
        rules: (contentId, request, resource) => [
          Allow([Operation.read], isSignedIn(request) && resource.data.public),
          Allow(
            [Operation.write],
            rules.firestore
                    .get<User>(
                      rules.path('/users/${request.auth?.uid}'.rules()),
                    )
                    .data
                    .contentIds
                    .rules<RulesString>()
                    .contains(contentId) &&
                rules.firestore.exists(
                  rules.path(
                    '/users/${request.auth?.uid}'.rules(),
                    database: 'default',
                  ),
                ),
          ),
        ],
      ),
    ],
  ),
];

abstract class User {
  List<String> get contentIds;
  Blob get profileImage;
}

abstract class Content {
  bool get public;
}
