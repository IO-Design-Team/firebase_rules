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
      .replaceAll('?.', '.')
      .replaceAllMapped(RegExp(r'\${(.+)}'), (m) => '\$(${m[1]})');
}
