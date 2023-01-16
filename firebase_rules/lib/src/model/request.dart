import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_rules/model.dart' as rules;

/// a map of JWT token claims.
abstract class RequestToken {
  RequestToken._();

  /// The email address associated with the account, if present
  String get email;

  /// `true` if the user has verified they have access to the `email` address.
  bool get emailVerified;

  /// The phone number associated with the account, if present.
  String get phoneNumber;

  /// The user's display name, if set.
  String get name;

  /// The user's Firebase UID. This is unique within a project.
  String get sub;

  /// A map of all the identities that are associated with this user's account.
  /// The keys of the map can be any of the following: `email`, `phone`,
  /// `google.com`, `facebook.com`, `github.com`, `twitter.com`. The values of
  /// the map are lists of unique identifiers for each identitity provider
  /// associated with the account. For example,
  /// `request.auth.token.firebase.identities["google.com"][0]` contains the
  /// first Google user ID associated with the account.
  Map<String, List<String>> get identities;

  /// The sign-in provider used to obtain this token. Can be one of the
  /// following strings: `custom`, `password`, `phone`, `anonymous`,
  /// `google.com`, `facebook.com`, `github.com`, `twitter.com`.
  String get signInProvider;

  /// The tenantId associated with the account, if present. e.g. `tenant2-m6tyz`
  String get tenantId;
}

/// Request authentication context.
abstract class RequestAuth {
  RequestAuth._();

  /// the UID of the requesting user.
  String get uid;

  /// a map of JWT token claims.
  RequestToken get token;
}

/// The request method.
enum RequestMethod {
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
abstract class RequestQuery {
  RequestQuery._();

  /// query limit clause.
  int get limit;

  /// query offset clause.
  int get offset;

  /// query orderBy clause.
  String get orderBy;
}

/// The incoming request context.
abstract class Request<T> {
  Request._();

  /// Request authentication context.
  RequestAuth? get auth;

  /// The request method.
  RequestMethod get method;

  /// Path of the affected resource.
  String get path;

  /// Map of query properties, when present.
  RequestQuery get query;

  /// The new resource value, present on write requests only.
  rules.Resource<T> get resource;

  /// When the request was received by the service.
  ///
  /// For Firestore write operations that include server-side timestamps, this
  /// time will be equal to the server timestamp.
  Timestamp get time;
}
