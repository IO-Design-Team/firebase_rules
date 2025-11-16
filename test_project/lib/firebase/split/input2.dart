// This is a test
// ignore_for_file: rexios_lints/not_null_assertion

import 'package:firebase_rules/firebase.dart';

bool isNotAnonymous(RulesRequest request) =>
    request.auth != null &&
    request.auth!.token.signInProvider != RulesSignInProvider.anonymous;

List<Allow> detachedRules(
  RulesString database,
  RulesRequest<FirestoreResource> request,
  FirestoreResource resource,
) =>
    [
      Allow([Operation.read], isNotAnonymous(request)),
    ];

List<Match> detachedMatches(
  RulesString database,
  RulesRequest<FirestoreResource> request,
  FirestoreResource resource,
) =>
    [
      Match<FirestoreResource<User>>('/users/{userId}', rules: detachedRules),
    ];

abstract class User {
  String get userId;
}
