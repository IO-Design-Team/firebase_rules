/// Perform the given [transforms] on the given [input]
String transform(String input, List<String Function(String input)> transforms) {
  for (final transform in transforms) {
    input = transform(input);
  }
  return input;
}

/// Remove rules prefixes and suffixes
String removeRulesPrefixesAndSuffixes(String input) => input
    // Remove `.rules<T...>()` suffixes
    .replaceAll(RegExp(r'\.rules(<.+?>)?\(\)'), '')
    // Remove `rules.` prefixes
    .replaceAll(RegExp(r'\brules\.'), '');

/// Strip null safety
String stripNullSafety(String input) => input
    .replaceAll('?.', '.')
    .replaceAll(']?', ']')
    .replaceAll('!.', '.')
    .replaceAll(']!', ']');

/// Translate raw strings
String translateRawStrings(String input) => input
    // Convert raw single quote strings
    // TODO: Needs work to avoid collisions
    .replaceAllMapped(RegExp(r"\br'(.+?)'"), (m) => "'${m[1]}'")
    // Convert raw double quote strings
    // TODO: Needs work to avoid collisions
    .replaceAllMapped(RegExp(r'\br"(.+?)"'), (m) => '"${m[1]}"');

/// Translate enums
String translateEnums(String input, Map<String, List<Enum>> enums) {
  for (final entry in enums.entries) {
    input = input.replaceAllMapped(
      RegExp(entry.key + r'\.([a-z]+)'),
      (m) {
        final value = entry.value.byName(m[1]!).toString();
        return "'$value'";
      },
    );
  }
  return input;
}

/// Translate user enums
String translateUserEnums(String input, Iterable<Map<String, String>> enums) {
  for (final enumMap in enums) {
    for (final entry in enumMap.entries) {
      input = input.replaceAll(entry.key, "'${entry.value}'");
    }
  }
  return input;
}

/// Translate auth variables
String translateAuthVariables(String input) => input
    .replaceAll('auth.token.emailVerified', 'auth.token.email_verified')
    .replaceAll('auth.token.phoneNumber', 'auth.token.phone_number')
    .replaceAll('auth.token.identities', 'auth.token.firebase.identities')
    .replaceAll(
      'auth.token.signInProvider',
      'auth.token.firebase.sign_in_provider',
    )
    .replaceAll('auth.token.tenant', 'auth.token.firebase.tenant')
    .replaceAllMapped(
      RegExp(r"auth\.token\.customClaim(<.+?>)?\('(.+?)'\)"),
      (m) => 'auth.token.${m[2]}',
    );
