import 'package:firebase_rules/database.dart';
import 'package:firebase_rules_generator/src/common/rules_context.dart';
import 'package:firebase_rules_generator/src/common/sanitizer.dart';

/// Sanitize rules files
String sanitizeRules(String input) {
  return transform(input, [
    removeRulesPrefixesAndSuffixes,
    stripNullSafety,
    translateRawStrings,
    (input) => translateEnums(input, {
          'RulesProvider': RulesProvider.values,
          'RulesIdentityProvider': RulesIdentityProvider.values,
          'RulesSignInProvider': RulesSignInProvider.values,
        }),
    translateAuthVariables,
    // Insert database regex
    (input) => input.replaceAllMapped(
          RegExp(r"\.matches\('(.+?)'\)"),
          (m) => '.matches(${m[1]})',
        ),

    // Remove types from `val()` calls
    (input) => input.replaceAll(RegExp(r'\.val<.+?>\(\)'), '.val()'),
  ]);
}

/// Sanitize path parameter prefixes from rules
String sanitizePaths(RulesContext context, String input) {
  var sanitized = input;
  for (final wildcard in context.wildcards) {
    sanitized =
        sanitized.replaceAll(RegExp(r'\b' + wildcard + r'\b'), '\$$wildcard');
  }
  return sanitized;
}
