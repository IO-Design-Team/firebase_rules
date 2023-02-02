import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    'a',
    write: (_) => newData.val<int>() < now,
  ),
];
