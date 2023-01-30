import 'package:firebase_rules/src/namespace/model/model.dart';
import 'package:firebase_rules/src/service/base.dart';

/// Identity providers
enum RulesIdentityProvider {
  /// email
  email,

  /// phone
  phone,

  /// google.com
  google,

  /// facebook.com
  facebook,

  /// github.com
  github,

  /// twitter.com
  twitter;

  /// The string representation of the identity provider
  @override
  String toString() {
    switch (this) {
      case RulesIdentityProvider.email:
        return 'email';
      case RulesIdentityProvider.phone:
        return 'phone';
      case RulesIdentityProvider.google:
        return 'google.com';
      case RulesIdentityProvider.facebook:
        return 'facebook.com';
      case RulesIdentityProvider.github:
        return 'github.com';
      case RulesIdentityProvider.twitter:
        return 'twitter.com';
    }
  }
}

/// Sign in providers
enum RulesSignInProvider {
  /// custom
  custom,

  /// password
  password,

  /// phone
  phone,

  /// anonymous
  anonymous,

  /// google.com
  google,

  /// facebook.com
  facebook,

  /// github.com
  github,

  /// twitter.com
  twitter;

  /// The string representation of the sign in provider
  @override
  String toString() {
    switch (this) {
      case RulesSignInProvider.custom:
        return 'custom';
      case RulesSignInProvider.password:
        return 'password';
      case RulesSignInProvider.phone:
        return 'phone';
      case RulesSignInProvider.anonymous:
        return 'anonymous';
      case RulesSignInProvider.google:
        return 'google.com';
      case RulesSignInProvider.facebook:
        return 'facebook.com';
      case RulesSignInProvider.github:
        return 'github.com';
      case RulesSignInProvider.twitter:
        return 'twitter.com';
    }
  }
}

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
  RulesMap<RulesIdentityProvider, RulesList<RulesString>> get identities;

  /// The sign-in provider used to obtain this token. Can be one of the
  /// following strings: `custom`, `password`, `phone`, `anonymous`,
  /// `google.com`, `facebook.com`, `github.com`, `twitter.com`.
  /// Translates to `firebase.sign_in_provider`
  ///
  /// Translates to `firebase.sign_in_provider`
  RulesSignInProvider get signInProvider;

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
  delete;

  @override
  String toString() => name;
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
