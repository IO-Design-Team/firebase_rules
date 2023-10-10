import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    r'rules/no/wildcard',
    // Invalid wildcard
    read: (asdf) => false,
  ),
];
