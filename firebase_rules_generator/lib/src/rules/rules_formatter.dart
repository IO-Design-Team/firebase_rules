import 'package:firebase_rules_generator/src/util.dart';

/// Generated file header we want to remove
const header = '''// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RulesGenerator
// **************************************************************************

''';

/// Format rules files
String formatRules(String input) {
  return input.remove(header);
}
