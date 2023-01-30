/// Primitive type representing a string value.
abstract class RulesString {
  /// Returns the length of the string.
  int get length;

  /// Returns true if the string contains the specified substring.
  bool contains(String substring);

  /// Returns true if the string begins with the specified substring.
  bool beginsWith(String substring);

  /// Returns true if the string ends with the specified substring.
  bool endsWith(String substring);

  /// Returns a copy of the string with all instances of a specified substring
  /// replaced with the specified replacement string.
  RulesString replace(String substring, String replacement);

  /// Returns a copy of the string converted to lower case.
  RulesString toLowerCase();

  /// Returns a copy of the string converted to upper case.
  RulesString toUpperCase();

  /// Returns true if the string matches the specified regular expression
  /// literal.
  // TODO: Convert to database rules regex
  bool matches(String regex);
}
