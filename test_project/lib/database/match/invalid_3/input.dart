import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    r'rules/$uid',
    // Invalid wildcard
    // expect_lint: invalid_match_function
    validate: (asdf) => false,
  ),
];
