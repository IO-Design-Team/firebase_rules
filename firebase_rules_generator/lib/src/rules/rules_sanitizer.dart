import 'package:firebase_rules/firebase_rules.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:firebase_rules_generator/src/util.dart';

/// Sanitize rules files
String sanitizeRules(FirebaseRules annotation, String input) {
  return input
      // Remove rules suffixes
      .remove('.rules')
      // Remove rules prefixes
      .remove('rules.')
      // Strip null safety
      .replaceAll('?.', '.')
      // Convert string interpolation
      .replaceAllMapped(RegExp(r'\${(.+?)}'), (m) => '\$(${m[1]})')
      // Convert raw single quote strings
      .replaceAllMapped(RegExp(r"r'(.+?)'"), (m) => "'${m[1]}'")
      // Convert raw double quote strings
      .replaceAllMapped(RegExp(r'r"(.+?)"'), (m) => "'${m[1]}'")
      // Convert firestore methods
      .replaceAllMapped(
        RegExp(r"firestore\.(.+?)(<.+?>)?\('(.+?)'\)"),
        (m) {
          final buffer = StringBuffer();
          if (annotation.service != Service.firestore) {
            buffer.write('firestore.');
          }
          buffer.write('${m[1]}(/databases/\$(database)/documents${m[3]})');
          return buffer.toString();
        },
      )
      // Convert `contains` to `x in y`
      .replaceAllMapped(
        RegExp(r'(\S+?|\[.+?)\.contains\((.+?)\)'),
        (m) => '${m[2]} in ${m[1]}',
      )
      // Convert `range` to `x[i:j]
      .replaceAllMapped(
        RegExp(r'(\S+?)\.range\((.+?), (.+?)\)'),
        (m) => '${m[1]}[${m[2]}:${m[3]}]',
      )
      // bool parsing
      .replaceAllMapped(RegExp(r'parseBool\((.+?)\)'), (m) => 'bool(${m[1]})')
      // bytes parsing
      .replaceAllMapped(RegExp(r"parseBytes\('(.+?)'\)"), (m) => "b'${m[1]}'")
      // float parsing
      .replaceAllMapped(RegExp(r'parseFloat\((.+?)\)'), (m) => 'float(${m[1]})')
      // int parsing
      .replaceAllMapped(RegExp(r'parseInt\((.+?)\)'), (m) => 'int(${m[1]})')
      // Raw rules string
      .replaceAllMapped(RegExp(r"raw\('(.+?)'\)"), (m) => m[1]!)
      // Convert duration.value
      .replaceAllMapped(
        RegExp(r'duration\.value\((.+?), RulesDurationUnit\.(.+?)\)'),
        (m) {
          final magnitude = m[1]!;
          final unit = RulesDurationUnit.values.byName(m[2]!).toString();
          return "duration.value($magnitude, '$unit')";
        },
      );
}

/// Sanitize path parameter prefixes from rules
String sanitizePaths(RulesContext context, String input) {
  var sanitized = '';
  for (final path in context.paths) {
    sanitized = input.replaceAll('$path.', '');
  }
  return sanitized;
}
