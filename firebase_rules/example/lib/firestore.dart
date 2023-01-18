import 'package:firebase_rules/firebase_rules.dart';

List<Match> matches(base, request, resource) => [
      Match<UsersPath, User>(
        rules: (users, request, resource) => [
          Rule([Operation.read], true),
          Rule([Operation.update], true),
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
                .contains(content.contentId),
          ),
        ],
      ),
    ];

@FirebaseRules(service: Service.firestore)
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
