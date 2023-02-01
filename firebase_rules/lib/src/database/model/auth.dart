import 'package:firebase_rules/database.dart';

/// Rules provider
enum RulesProvider {
  /// password
  password,

  /// anonymous
  anonymous,

  /// facebook
  facebook,

  /// github
  github,

  /// google
  google,

  /// twitter
  twitter;

  @override
  String toString() => name;
}

/// a map of JWT token claims.
abstract class RulesToken {
  RulesToken._();

  /// Access to custom claims
  T customClaim<T>(String key);

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
  Map<RulesIdentityProvider, List<RulesString>> get identities;

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
abstract class RulesAuth {
  RulesAuth._();

  /// The authentication method used (e.g "password", "anonymous", "facebook",
  /// "github", "google", or "twitter").
  RulesProvider get provider;

  /// the UID of the requesting user.
  RulesString get uid;

  /// a map of JWT token claims.
  RulesToken get token;
}
