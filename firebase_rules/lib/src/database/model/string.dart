/// Primitive type representing a string value.
abstract class RulesString {
  /// Add two strings together.
  RulesString operator +(RulesString other);

  /// Returns the length of the string.
  int get length;

  /// Returns true if the string contains the specified substring.
  bool contains(RulesString substring);

  /// Returns true if the string begins with the specified substring.
  bool beginsWith(RulesString substring);

  /// Returns true if the string ends with the specified substring.
  bool endsWith(RulesString substring);

  /// Returns a copy of the string with all instances of a specified substring
  /// replaced with the specified replacement string.
  RulesString replace(RulesString substring, RulesString replacement);

  /// Returns a copy of the string converted to lower case.
  RulesString toLowerCase();

  /// Returns a copy of the string converted to upper case.
  RulesString toUpperCase();

  /// Returns true if the string matches the specified regular expression
  /// literal.
  bool matches(String regex);
}
