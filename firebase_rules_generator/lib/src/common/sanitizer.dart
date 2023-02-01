/// Perform the given [transforms] on the given [input]
String transform(String input, List<String Function(String input)> transforms) {
  for (final transform in transforms) {
    input = transform(input);
  }
  return input;
}

/// Remove rules prefixes and suffixes
String removeRulesPrefixesAndSuffixes(String input) => input
    // Remove rules suffixes
    .replaceAll(RegExp(r'\.rules\b'), '')
    // Remove rules prefixes
    .replaceAll(RegExp(r'\brules\.'), '');

/// Strip null safety
String stripNullSafety(String input) =>
    input.replaceAll('?.', '.').replaceAll('?[', '[').replaceAll('!.', '.');

/// Translate strings
String translateStrings(String input) => input
    // Convert string interpolation
    .replaceAllMapped(RegExp(r'\${(.+?)}'), (m) => '\$(${m[1]})')
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
