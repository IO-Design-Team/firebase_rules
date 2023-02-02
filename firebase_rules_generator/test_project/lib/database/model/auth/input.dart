import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match('a', read: (_) => auth?.provider == RulesProvider.password),
  Match('b', read: (_) => auth?.provider == RulesProvider.anonymous),
  Match('c', read: (_) => auth?.provider == RulesProvider.facebook),
  Match('d', read: (_) => auth?.provider == RulesProvider.github),
  Match('e', read: (_) => auth?.provider == RulesProvider.google),
  Match('f', read: (_) => auth?.provider == RulesProvider.twitter),
  Match('g', read: (_) => auth?.uid == 'asdf'.rules()),
  Match('h', read: (_) => auth!.token.email.contains('@google.com'.rules())),
  Match('i', read: (_) => auth!.token.emailVerified),
  Match(
    'j',
    read: (_) =>
        auth!.token.identities[RulesIdentityProvider.email]?[0] != null,
  ),
  Match(
    'k',
    read: (_) =>
        auth!.token.identities[RulesIdentityProvider.phone]?[0] != null,
  ),
  Match(
    'l',
    read: (_) =>
        auth!.token.identities[RulesIdentityProvider.google]?[0] != null,
  ),
  Match(
    'm',
    read: (_) =>
        auth!.token.identities[RulesIdentityProvider.facebook]?[0] != null,
  ),
  Match(
    'n',
    read: (_) =>
        auth!.token.identities[RulesIdentityProvider.github]?[0] != null,
  ),
  Match(
    'o',
    read: (_) =>
        auth!.token.identities[RulesIdentityProvider.twitter]?[0] != null,
  ),
  Match(
    'p',
    read: (_) => auth!.token.signInProvider == RulesSignInProvider.custom,
  ),
  Match(
    'q',
    read: (_) => auth!.token.signInProvider == RulesSignInProvider.password,
  ),
  Match(
    'r',
    read: (_) => auth!.token.signInProvider == RulesSignInProvider.phone,
  ),
  Match(
    's',
    read: (_) => auth!.token.signInProvider == RulesSignInProvider.anonymous,
  ),
  Match(
    't',
    read: (_) => auth!.token.signInProvider == RulesSignInProvider.google,
  ),
  Match(
    'u',
    read: (_) => auth!.token.signInProvider == RulesSignInProvider.facebook,
  ),
  Match(
    'v',
    read: (_) => auth!.token.signInProvider == RulesSignInProvider.github,
  ),
  Match(
    'w',
    read: (_) => auth!.token.signInProvider == RulesSignInProvider.twitter,
  ),
  Match('x', read: (_) => auth!.token.tenant == 'tenant2-m6tyz'.rules()),
];
