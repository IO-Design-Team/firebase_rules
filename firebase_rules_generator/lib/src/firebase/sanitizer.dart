import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/sanitizer.dart';

/// Sanitize rules files
String sanitizeRules(FirebaseRules annotation, String input) {
  return transformIgnoringRaws(input, [
    removeRulesPrefixesAndSuffixes,
    stripNullSafety,
    translateStrings,
    (input) => input
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
        ),
    (input) => input
        // Convert `contains` to `x in y`
        .replaceAllMapped(
          RegExp(r'(\S+?|\[.+?|\{.+?)\.contains\((.+?)\)'),
          (m) => '${m[2]} in ${m[1]}',
        )
        // Convert `range` to `x[i:j]
        .replaceAllMapped(
          RegExp(r'(\S+?)\.range\((.+?), (.+?)\)'),
          (m) => '${m[1]}[${m[2]}:${m[3]}]',
        ),
    (input) => input
        // bool parsing
        .replaceAllMapped(RegExp(r'parseBool\((.+?)\)'), (m) => 'bool(${m[1]})')
        // bytes parsing
        .replaceAllMapped(RegExp(r"parseBytes\('(.+?)'\)"), (m) => "b'${m[1]}'")
        // float parsing
        .replaceAllMapped(
            RegExp(r'parseFloat\((.+?)\)'), (m) => 'float(${m[1]})')
        // int parsing
        .replaceAllMapped(RegExp(r'parseInt\((.+?)\)'), (m) => 'int(${m[1]})'),
    (input) => translateEnums(input, {
          'RulesDurationUnit': RulesDurationUnit.values,
          'RulesMethod': RulesMethod.values,
          'RulesIdentityProvider': RulesIdentityProvider.values,
          'RulesSignInProvider': RulesSignInProvider.values,
        }),
    translateAuthVariables,
    (input) => input.replaceAll(
          'resource.firestoreResourceName',
          "resource['__name__']",
        ),
  ]);
}

/// Extract raw rules strings, replace them with placeholders, sanitize the
/// input, then replace the placeholders with the raw rules strings
String transformIgnoringRaws(
  String input,
  List<String Function(String input)> transforms,
) {
  final raws = <String>[];
  input =
      input.replaceAllMapped(RegExp(r'''rules\.raw\(['"](.+?)['"]\)'''), (m) {
    raws.add(m[1]!);
    return '{RulesRawPlaceholder${raws.length - 1}}';
  });

  input = transform(input, transforms);

  for (var i = 0; i < raws.length; i++) {
    input = input.replaceFirst('{RulesRawPlaceholder$i}', raws.elementAt(i));
  }

  return input;
}

/// Sanitize path parameter prefixes from rules
String sanitizePaths(Context context, String input) {
  var sanitized = input;
  for (final path in context.paths) {
    sanitized = sanitized.replaceAll(RegExp(r'\b' + path + r'\.'), '');
  }
  return sanitized;
}
