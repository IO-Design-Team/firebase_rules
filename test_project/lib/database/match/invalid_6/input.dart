import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    // Too many wildcards
    r'rules/$too/$many',
    read: (too) => false,
  ),
];
