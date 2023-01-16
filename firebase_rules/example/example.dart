import 'package:firebase_rules/firebase_rules.dart';

@FirebaseRules(service: Service.firestore)
final matches = [
  Match<FirestorePath, dynamic>(
    matches: (base, request, resource) => [
      Match<UsersPath, User>(
        rules: (users, request, resource) => [
          Rule([Operation.read], request.auth != null),
          Rule([Operation.update], request.auth?.uid == users.userId),
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
            firestore
                .get<User>('/users/${request.auth?.uid}')
                .contentIds
                // TODO: Change to `in`
                .contains(content.contentId),
          ),
        ],
      ),
    ],
  ),
];

abstract class User {
  List<String> get contentIds;
}

abstract class Content {
  bool get public;
}

class UsersPath extends Path {
  String get userId => throw UnimplementedError();

  @override
  String get path => 'users/$userId';
}

class ContentPath extends Path {
  String get contentId => throw UnimplementedError();

  @override
  String get path => 'content/$contentId';
}
