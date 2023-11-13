import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    // Too many wildcards
    // expect_lint: invalid_match_path
    r'rules/$too/$many',
    read: (too) => false,
  ),
];
