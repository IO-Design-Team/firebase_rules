// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

@RulesFunction()
bool test1(RulesRequest request) {
  final a = request.auth != null;
  final b = request.auth?.uid;
  final c = request.auth?.token.email;
  final d = request.auth?.token.emailVerified;
  final e = request.auth?.token.phoneNumber;
  final f = request.auth?.token.name;
  final g = request.auth?.token.sub;
  final h = request.auth?.token.identities;
  final i = request.auth?.token.signInProvider;
  final j = request.auth?.token.tenant;
  final k = request.method == RulesRequestMethod.get;
  final l = request.method == RulesRequestMethod.list;
  final m = request.method == RulesRequestMethod.create;
  final n = request.method == RulesRequestMethod.update;
  final o = request.method == RulesRequestMethod.delete;
  final p = request.path;
  final q = request.query.limit;
  final r = request.query.offset;
  final s = request.query.orderBy;
  final t = request.resource;
  final u = request.time;
  return true;
}

@RulesFunction()
bool test2(RulesRequest request) {
  final a = request.auth?.token.identities[RulesIdentityProvider.email]?[0];
  final b = request.auth?.token.identities[RulesIdentityProvider.phone]?[0];
  final c = request.auth?.token.identities[RulesIdentityProvider.google]?[0];
  final d = request.auth?.token.identities[RulesIdentityProvider.facebook]?[0];
  final e = request.auth?.token.identities[RulesIdentityProvider.github]?[0];
  final f = request.auth?.token.identities[RulesIdentityProvider.twitter]?[0];
  final g = request.auth?.token.signInProvider == RulesSignInProvider.custom;
  final h = request.auth?.token.signInProvider == RulesSignInProvider.password;
  final i = request.auth?.token.signInProvider == RulesSignInProvider.phone;
  final j = request.auth?.token.signInProvider == RulesSignInProvider.anonymous;
  final k = request.auth?.token.signInProvider == RulesSignInProvider.google;
  final l = request.auth?.token.signInProvider == RulesSignInProvider.facebook;
  final m = request.auth?.token.signInProvider == RulesSignInProvider.github;
  final n = request.auth?.token.signInProvider == RulesSignInProvider.twitter;
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = <Match>[];
