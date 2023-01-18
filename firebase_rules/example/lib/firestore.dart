import 'package:firebase_rules/firebase_rules.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestorePath, dynamic>(
    matches: (base, request, resource) {
      bool isSignedIn() => request.auth != null;
      bool isOwner(RulesString uid) {
        final requestingUid = request.auth?.uid;
        return requestingUid == uid;
      }

      return [
        Match<UsersPath, User>(
          rules: (users, request, resource) => [
            Rule([Operation.read], isSignedIn()),
            Rule([Operation.update], isOwner(users.userId.rules)),
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
    },
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
