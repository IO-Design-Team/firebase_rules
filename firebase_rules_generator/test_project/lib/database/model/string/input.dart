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
        newData.isString() && newData.val<RulesString>().contains('@'.rules),
  ),
  Match(
    'c',
    read: (_) => auth!.token
        .customClaim<RulesString>('identifier')
        .beginsWith('internal-'.rules),
  ),
  Match(
    'd',
    read: (_) => auth!.token
        .customClaim<RulesString>('identifier')
        .endsWith('@company.com'.rules),
  ),
  Match()
];
