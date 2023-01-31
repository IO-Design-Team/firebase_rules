import 'package:firebase_rules/database.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/sanitizer.dart';

/// Sanitize rules files
String sanitizeRules(String input) {
  final pass1 = removeRulesPrefixesAndSuffixes(input);
  final pass2 = stripNullSafety(pass1);
  final pass3 = translateStrings(pass2);
  final pass4 = translateEnums(pass3, {
    'RulesProvider': RulesProvider.values,
    'RulesIdentityProvider': RulesIdentityProvider.values,
    'RulesSignInProvider': RulesSignInProvider.values,
  });
  final pass5 = translateAuthVariables(pass4);
  return pass5;
}

/// Sanitize path parameter prefixes from rules
String sanitizePaths(Context context, String input) {
  var sanitized = input;
  for (final path in context.paths) {
    sanitized = sanitized.replaceAll(RegExp(r'\b' + path + r'\b'), '\$$path');
  }
  return sanitized;
}
