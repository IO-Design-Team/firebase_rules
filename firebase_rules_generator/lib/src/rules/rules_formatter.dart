const header = '''// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RulesGenerator
// **************************************************************************

''';

extension on String {
  /// Remove all occurrences of [substring] from this string
  String remove(String substring) => replaceAll(substring, '');
}

/// Sanitize rules files
String formatRules(String input) {
  return input
      .remove(header)
      .remove('.rules')
      .remove('rules.')
      // Strip null safety
      .replaceAll('?.', '.')
      // Convert string interpolation
      .replaceAllMapped(RegExp(r'\${(.+)}'), (m) => '\$(${m[1]})')
      // Convert firestore methods
      .replaceAllMapped(
        RegExp(r"firestore.(.+)<.+'(.*?)'\)"),
        (m) => 'firestore.${m[1]}(/databases/\$(database)/documents${m[2]})',
        // Convert `contains` to `x in y`
      )
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
