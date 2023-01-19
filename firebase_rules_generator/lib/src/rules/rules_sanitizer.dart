import 'package:firebase_rules/firebase_rules.dart';
import 'package:firebase_rules_generator/src/util.dart';

/// Sanitize rules files
String sanitizeRules(FirebaseRules annotation, String input) {
  return input
      .remove('.rules')
      .remove('rules.')
      // Strip null safety
      .replaceAll('?.', '.')
      // Convert string interpolation
      .replaceAllMapped(RegExp(r'\${(.+)}'), (m) => '\$(${m[1]})')
      // Convert firestore methods
      .replaceAllMapped(
        RegExp(r"firestore.(.+)<.+'(.*?)'\)"),
        (m) {
          final buffer = StringBuffer();
          if (annotation.service != Service.firestore) {
            buffer.write('firestore.');
          }
          buffer.write('${m[1]}(/databases/\$(database)/documents${m[2]})');
          return buffer.toString();
        },
      )
      // Convert `contains` to `x in y`
      .replaceAllMapped(
        RegExp(r'(\S+)\.contains\((.+?)\)'),
        (m) => '${m[2]} in ${m[1]}',
      )
      // Convert `range` to `x[i:j]
      .replaceAllMapped(
        RegExp(r'(\S+)\.range\((.+?), (.+?)\)'),
        (m) => '${m[1]}[${m[2]}:${m[3]}]',
      );
}
