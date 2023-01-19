<!-- embedme lib/firestore.dart -->
```dart
import 'package:firebase_rules/firebase_rules.dart';

@RulesFunction()
bool isSignedIn(RulesRequest request) => request.auth != null;

@RulesFunction()
bool isOwner(RulesRequest request, RulesString uid) {
  final requestingUid = request.auth?.uid;
  return requestingUid == uid;
}

List<Match> matches(
  FirestorePath path,
  RulesRequest request,
  RulesResource resource,
) =>
    [
      Match<UsersPath, User>(
        rules: (users, request, resource) => [
          Rule([Operation.read], isSignedIn(request)),
          Rule([Operation.update], isOwner(request, users.userId.rules)),
        ],
      ),
      Match<ContentPath, Content>(
        rules: (content, request, resource) => [
          Rule(
            [Operation.read],
            request.auth != null && resource.data.public,
          ),
          Rule(
            [Operation.write],
            rules.firestore
                    .get<User>('/users/${request.auth?.uid}'.rules)
                    .contentIds
                    .rules
                    .contains(content.contentId) &&
                rules.firestore.exists('/users/${request.auth?.uid}'.rules),
          ),
        ],
      ),
    ];

@FirebaseRules(
  service: Service.firestore,
  // debug: true,
)
final firestoreRules = [
  Match<FirestorePath, dynamic>(
    rules: (FirestorePath path, request, resource) => [
      Rule([Operation.read], request.auth?.uid == 'god'.rules),
    ],
    matches: matches,
  ),
];

abstract class User {
  List<String> get contentIds;
}

abstract class Content {
  bool get public;
}

abstract class UsersPath extends FirebasePath {
  String get userId;

  @override
  String get path => '/users/$userId';
}

abstract class ContentPath extends FirebasePath {
  String get contentId;

  @override
  String get path => '/content/$contentId';
}

```