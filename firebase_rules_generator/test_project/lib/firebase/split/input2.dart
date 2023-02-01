// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool isNotAnonymous(RulesRequest request) =>
    request.auth != null &&
    request.auth!.token.signInProvider != RulesSignInProvider.anonymous;

List<Allow> detachedRules(
  FirebasePath path,
  RulesRequest<FirestoreResource> request,
  FirestoreResource resource,
) =>
    [
      Allow([Operation.read], isNotAnonymous(request)),
    ];

List<Match> detachedMatches(
  FirebasePath path,
  RulesRequest<FirestoreResource> request,
  FirestoreResource resource,
) =>
    [
      Match<UsersPath, FirestoreResource<User>>(rules: detachedRules),
    ];

abstract class UsersPath extends FirebasePath {
  String get userId;

  @override
  String get path => '/users/$userId';
}

abstract class User {
  String get userId;
}
