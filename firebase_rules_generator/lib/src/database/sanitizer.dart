import 'package:firebase_rules/database.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
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
String sanitizePaths(Context context, String input) {
  var sanitized = input;
  for (final path in context.paths) {
    sanitized = sanitized.replaceAll(RegExp(r'\b' + path + r'\b'), '\$$path');
  }
  return sanitized;
}
