import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    r'rules/no/wildcard',
    // Invalid wildcard
    // expect_lint: invalid_match_function
    read: (asdf) => false,
  ),
];
