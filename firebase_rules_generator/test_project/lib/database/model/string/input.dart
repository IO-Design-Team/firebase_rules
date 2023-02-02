import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    'a',
    validate: (_) =>
        newData.isString() && newData.val<RulesString>().length >= 10,
  ),
  Match(
    'b',
    validate: (_) =>
        newData.isString() && newData.val<RulesString>().contains('@'.rules()),
  ),
  Match(
    'c',
    read: (_) => auth!.token
        .customClaim<RulesString>('identifier')
        .beginsWith('internal-'.rules()),
  ),
  Match(
    'd',
    read: (_) => auth!.token
        .customClaim<RulesString>('identifier')
        .endsWith('@company.com'.rules()),
  ),
  Match(
    'e',
    write: (_) => root
        .child('whitelist'.rules())
        .child(
          newData
              .child('email'.rules())
              .val<RulesString>()
              .replace('.'.rules(), '%2E'.rules()),
        )
        .exists(),
  ),
  Match(
    'f',
    read: (_) => root
        .child('users'.rules())
        .child(auth!.token.customClaim<RulesString>('identifier').toLowerCase())
        .exists(),
  ),
  Match(
    'g',
    read: (_) => root
        .child('users'.rules())
        .child(auth!.token.customClaim<RulesString>('identifier').toUpperCase())
        .exists(),
  ),
  Match(
    'h',
    validate: (_) =>
        newData.isString() &&
        newData.val().matches(r'/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$/i'),
  )
];
