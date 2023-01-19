import 'package:firebase_rules/src/namespace/model/model.dart';
import 'package:firebase_rules/src/service/base.dart';

/// a map of JWT token claims.
abstract class RulesRequestToken {
  RulesRequestToken._();

  /// The email address associated with the account, if present
  RulesString get email;

  /// `true` if the user has verified they have access to the `email` address.
  ///
  /// Translates to `email_verified`
  bool get emailVerified;

  /// The phone number associated with the account, if present.
  ///
  /// Translates to `phone_number`
  RulesString get phoneNumber;

  /// The user's display name, if set.
  RulesString get name;

  /// The user's Firebase UID. This is unique within a project.
  RulesString get sub;

  /// A map of all the identities that are associated with this user's account.
  /// The keys of the map can be any of the following: `email`, `phone`,
  /// `google.com`, `facebook.com`, `github.com`, `twitter.com`. The values of
  /// the map are lists of unique identifiers for each identitity provider
  /// associated with the account. For example,
  /// `request.auth.token.firebase.identities["google.com"][0]` contains the
  /// first Google user ID associated with the account.
  ///
  /// Translates to `firebase.identities`
  RulesMap<RulesString, RulesList<RulesString>> get identities;

  /// The sign-in provider used to obtain this token. Can be one of the
  /// following strings: `custom`, `password`, `phone`, `anonymous`,
  /// `google.com`, `facebook.com`, `github.com`, `twitter.com`.
  /// Translates to `firebase.sign_in_provider`
  ///
  /// Translates to `firebase.sign_in_provider`
  RulesString get signInProvider;

  /// The tenantId associated with the account, if present. e.g. `tenant2-m6tyz`
  ///
  /// Translates to `firebase.tenant`
  RulesString get tenant;
}

/// Request authentication context.
abstract class RulesRequestAuth {
  RulesRequestAuth._();

  /// the UID of the requesting user.
  RulesString get uid;

  /// a map of JWT token claims.
  RulesRequestToken get token;
}

/// The request method.
enum RulesRequestMethod {
  /// get
  get,

  /// list
  list,

  /// create
  create,

  /// update
  update,

  /// delete
  delete,
}

/// Map of query properties, when present.
abstract class RulesRequestQuery {
  RulesRequestQuery._();

  /// query limit clause.
  int get limit;

  /// query offset clause.
  int get offset;

  /// query orderBy clause.
  RulesString get orderBy;
}

/// The incoming request context.
abstract class RulesRequest<T extends FirebaseResource> {
  RulesRequest._();

  /// Request authentication context.
  RulesRequestAuth? get auth;

  /// The request method.
  RulesRequestMethod get method;

  /// Path of the affected resource.
  RulesPath get path;

  /// Map of query properties, when present.
  RulesRequestQuery get query;

  /// The new resource value, present on write requests only.
  T get resource;

  /// When the request was received by the service.
  ///
  /// For Firestore write operations that include server-side timestamps, this
  /// time will be equal to the server timestamp.
  RulesTimestamp get time;
}
