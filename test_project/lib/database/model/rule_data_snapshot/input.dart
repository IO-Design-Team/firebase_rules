import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match('a', read: (_) => data.child('isReadable'.rules()).val() == true),
  Match(
    'b',
    read: (_) => data.parent().child('isReadable'.rules()).val() == true,
  ),
  Match('c', validate: (_) => newData.hasChild('name'.rules())),
  Match('d', validate: (_) => newData.hasChildren()),
  Match(
    'e',
    validate: (_) => newData.hasChildren(['name'.rules(), 'age'.rules()]),
  ),
  Match('f', write: (_) => !data.exists()),
  Match('g', validate: (_) => newData.getPriority() != null),
  Match('h', validate: (_) => newData.child('age'.rules()).isNumber()),
  Match('i', validate: (_) => newData.child('name'.rules()).isString()),
  Match('j', validate: (_) => newData.child('active'.rules()).isBoolean()),
];
