import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_generator/src/common/sanitizer.dart';
import 'package:firebase_rules_generator/src/firebase/revived_firebase_rules.dart';

/// Sanitize rules files
String sanitizeRules(RevivedFirebaseRules annotation, String input) {
  return transformIgnoringRaws(input, [
    removeRulesPrefixesAndSuffixes,
    stripNullSafety,
    translateRawStrings,
    (input) => input
        // Convert non-braced string interpolation
        .replaceAllMapped(RegExp(r'\$([^{}]+?)\b'), (m) => '\$(${m[1]})')
        // Convert braced string interpolation
        .replaceAllMapped(RegExp(r'\${(.+?)}'), (m) => '\$(${m[1]})'),
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
            // Translate all paths
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
        )
            // Convert path strings to raw paths
            .replaceAllMapped(
          RegExp(r"path\('(.+?)'\)(\.bind\((.+?)\))?"),
          (m) => m[2] != null ? '(${m[1]}).bind(${m[3]})' : m[1]!,
        ),
    (input) => input
            // Convert `contains` to `x in y`
            .replaceAllMapped(
          RegExp(r'(!)?(\S+?|\[.+?|\{.+?)\.contains\((.+?)\)'),
          (m) {
            if (m[1] != null) {
              return '!(${m[3]} in ${m[2]})';
            } else {
              return '${m[3]} in ${m[2]}';
            }
          },
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
          RegExp(r'parseFloat\((.+?)\)'),
          (m) => 'float(${m[1]})',
        )
        // int parsing
        .replaceAllMapped(RegExp(r'parseInt\((.+?)\)'), (m) => 'int(${m[1]})'),
    (input) => translateEnums(input, {
          'RulesDurationUnit': RulesDurationUnit.values,
          'RulesMethod': RulesMethod.values,
          'RulesIdentityProvider': RulesIdentityProvider.values,
          'RulesSignInProvider': RulesSignInProvider.values,
        }),
    (input) => translateUserEnums(input, annotation.enums),
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
  input = input.replaceAllMapped(
      RegExp(r'''rules\.raw(<.+?>)?\(['"](.+?)['"]\)'''), (m) {
    raws.add(m[2]!);
    return '{RulesRawPlaceholder${raws.length - 1}}';
  });

  input = transform(input, transforms);

  for (var i = 0; i < raws.length; i++) {
    input = input.replaceFirst('{RulesRawPlaceholder$i}', raws.elementAt(i));
  }

  return input;
}
