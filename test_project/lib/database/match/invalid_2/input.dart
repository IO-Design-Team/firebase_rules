import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    r'rules/$uid',
    // Invalid wildcard
    write: (asdf) => false,
  ),
];