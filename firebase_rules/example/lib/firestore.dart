import 'package:firebase_rules/firebase_rules.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

@RulesFunction()
bool isSignedIn(RulesRequest request) => request.auth != null;

@RulesFunction()
bool isOwner(RulesRequest request, RulesString uid) {
  final requestingUid = request.auth?.uid;
  return requestingUid == uid;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestorePath, FirestoreResource>(
    rules: (path, request, resource) => [
      Allow([Operation.read], request.auth?.uid == 'god'.rules),
    ],
    matches: (path, request, resource) => [
      Match<UsersPath, FirestoreResource<User>>(
        rules: (users, request, resource) => [
          Allow([Operation.read], isSignedIn(request)),
          Allow(
            [Operation.create, Operation.update],
            isOwner(request, users.userId.rules),
          ),
        ],
      ),
      Match<ContentPath, FirestoreResource<Content>>(
        rules: (content, request, resource) => [
          Allow(
            [Operation.read],
            isSignedIn(request) && resource.data.public,
          ),
          Allow(
            [Operation.write],
            rules.firestore
                    .get<User>(rules.path('/users/${request.auth?.uid}'.rules))
                    .contentIds
                    .rules
                    .contains(content.contentId) &&
                rules.firestore.exists(
                  rules.path(
                    '/users/${request.auth?.uid}'.rules,
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

abstract class UsersPath extends FirebasePath {
  String get userId;

  @override
  String get path => '/users/$userId';
}

abstract class Content {
  bool get public;
}

abstract class ContentPath extends FirebasePath {
  String get contentId;

  @override
  String get path => '/content/$contentId';
}
