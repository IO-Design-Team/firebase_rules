import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/sanitizer.dart';

/// Sanitize rules files
String sanitizeRules(FirebaseRules annotation, String input) {
  final pass1 = removeRulesPrefixesAndSuffixes(input);
  final pass2 = stripNullSafety(pass1);
  final pass3 = translateStrings(pass2);

  final pass4 = pass3
      // Convert firestore methods
      .replaceAllMapped(
    RegExp(r'firestore\.(.+?)(<.+?>)?\((.+?)\)'),
    (m) {
      final buffer = StringBuffer();
      if (annotation.service != Service.firestore) {
        buffer.write('firestore.');
      }
      buffer.write('${m[1]}(${m[3]})');
      return buffer.toString();
    },
  )
      // Convert all paths
      .replaceAllMapped(
    RegExp(r"path\('(.+?)'(, database: '(.+?)')?\)"),
    (m) {
      final database = m[3];
      final String path;
      if (database == null) {
        path = '/databases/\$(database)/documents${m[1]}';
      } else {
        path = '/databases/($database)/documents${m[1]}';
      }
      return 'path(\'$path\')';
    },
  );

  final pass5 = pass4
      // Convert `contains` to `x in y`
      .replaceAllMapped(
        RegExp(r'(\S+?|\[.+?|\{.+?)\.contains\((.+?)\)'),
        (m) => '${m[2]} in ${m[1]}',
      )
      // Convert `range` to `x[i:j]
      .replaceAllMapped(
        RegExp(r'(\S+?)\.range\((.+?), (.+?)\)'),
        (m) => '${m[1]}[${m[2]}:${m[3]}]',
      );

  final pass6 = pass5
      // bool parsing
      .replaceAllMapped(RegExp(r'parseBool\((.+?)\)'), (m) => 'bool(${m[1]})')
      // bytes parsing
      .replaceAllMapped(RegExp(r"parseBytes\('(.+?)'\)"), (m) => "b'${m[1]}'")
      // float parsing
      .replaceAllMapped(RegExp(r'parseFloat\((.+?)\)'), (m) => 'float(${m[1]})')
      // int parsing
      .replaceAllMapped(RegExp(r'parseInt\((.+?)\)'), (m) => 'int(${m[1]})');

  final pass7 = pass6
      // Raw rules string
      .replaceAllMapped(RegExp(r"raw\('(.+?)'\)"), (m) => m[1]!);

  final pass8 = translateEnums(pass7, {
    'RulesDurationUnit': RulesDurationUnit.values,
    'RulesRequestMethod': RulesRequestMethod.values,
    'RulesIdentityProvider': RulesIdentityProvider.values,
    'RulesSignInProvider': RulesSignInProvider.values,
  });

  final pass9 = translateAuthVariables(pass8);

  final pass10 = pass9.replaceAll(
    'resource.firestoreResourceName',
    "resource['__name__']",
  );

  return pass10;
}

/// Sanitize path parameter prefixes from rules
String sanitizePaths(Context context, String input) {
  var sanitized = '';
  for (final path in context.paths) {
    sanitized = input.replaceAll('$path.', '');
  }
  return sanitized;
}
