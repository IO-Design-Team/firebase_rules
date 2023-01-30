import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:firebase_rules_generator/src/util.dart';

/// Sanitize rules files
String sanitizeRules(FirebaseRules annotation, String input) {
  final pass1 = input
      // Remove rules suffixes
      .remove('.rules')
      // Remove rules prefixes
      .remove('rules.');

  // Strip null safety
  final pass2 = pass1.replaceAll('?.', '.').replaceAll('?[', '[');

  final pass3 = pass2
      // Convert string interpolation
      .replaceAllMapped(RegExp(r'\${(.+?)}'), (m) => '\$(${m[1]})')
      // Convert raw single quote strings
      // TODO: Needs work to avoid collisions
      .replaceAllMapped(RegExp(r"\br'(.+?)'"), (m) => "'${m[1]}'")
      // Convert raw double quote strings
      // TODO: Needs work to avoid collisions
      .replaceAllMapped(RegExp(r'\br"(.+?)"'), (m) => "'${m[1]}'");

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

  final pass8 = pass7
      // Convert RulesDurationUnit
      .replaceAllMapped(
    RegExp(r'RulesDurationUnit\.([a-z]+)'),
    (m) {
      final unit = RulesDurationUnit.values.byName(m[1]!).toString();
      return "'$unit'";
    },
  )
      // Convert RequestMethod
      .replaceAllMapped(
    RegExp(r'RulesRequestMethod\.([a-z]+)'),
    (m) {
      final method = RulesRequestMethod.values.byName(m[1]!).toString();
      return "'$method'";
    },
  ).replaceAllMapped(
    RegExp(r'RulesIdentityProvider\.([a-z]+)'),
    (m) {
      final provider = RulesIdentityProvider.values.byName(m[1]!).toString();
      return "'$provider'";
    },
  ).replaceAllMapped(
    RegExp(r'RulesSignInProvider\.([a-z]+)'),
    (m) {
      final provider = RulesSignInProvider.values.byName(m[1]!).toString();
      return "'$provider'";
    },
  );

  final pass9 = pass8
      .replaceAll('auth.token.emailVerified', 'auth.token.email_verified')
      .replaceAll('auth.token.phoneNumber', 'auth.token.phone_number')
      .replaceAll('auth.token.identities', 'auth.token.firebase.identities')
      .replaceAll(
        'auth.token.signInProvider',
        'auth.token.firebase.sign_in_provider',
      )
      .replaceAll('auth.token.tenant', 'auth.token.firebase.tenant')
      .replaceAll('resource.firestoreResourceName', "resource['__name__']");

  return pass9;
}

/// Sanitize path parameter prefixes from rules
String sanitizePaths(RulesContext context, String input) {
  var sanitized = '';
  for (final path in context.paths) {
    sanitized = input.replaceAll('$path.', '');
  }
  return sanitized;
}
