import 'package:firebase_rules/firebase_rules.dart';

@FirebaseRules(
  service: Service.firestore,
  // debug: true,
)
final firestoreRules = [
  Match<FirestorePath, dynamic>((FirestorePath path, request, resource) {
    bool isSignedIn() => request.auth != null;
    bool isOwner(RulesString uid) {
      final requestingUid = request.auth?.uid;
      return requestingUid == uid;
    }

    return MatchBody(
      rules: [
        Rule([Operation.read], request.auth?.uid == 'god'.rules),
      ],
      matches: [
        Match<UsersPath, User>(
          (users, request, resource) => MatchBody(
            rules: [
              Rule([Operation.read], isSignedIn()),
              Rule([Operation.update], isOwner(users.userId.rules)),
            ],
          ),
        ),
        Match<ContentPath, Content>(
          (content, request, resource) => MatchBody(
            rules: [
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
                    .contains(content.contentId),
              ),
            ],
          ),
        ),
      ],
    );
  }),
];

abstract class User {
  List<String> get contentIds;
}

abstract class Content {
  bool get public;
}

class UsersPath extends FirebasePath {
  String get userId => throw UnimplementedError();

  @override
  String get path => '/users/$userId';
}

class ContentPath extends FirebasePath {
  String get contentId => throw UnimplementedError();

  @override
  String get path => '/content/$contentId';
}
