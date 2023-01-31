/// Generated file header we want to remove
String headerForGenerator(String name) => '''
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// $name
// **************************************************************************

''';

/// Format rules files
String formatRules(String generatorName, String input) {
  return input.replaceFirst(headerForGenerator(generatorName), '');
}
