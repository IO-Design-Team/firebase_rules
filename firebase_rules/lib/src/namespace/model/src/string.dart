import 'package:firebase_rules/src/namespace/model/model.dart';

/// Primitive type representing a string value.
abstract class RulesString {
  RulesString._();

  /// Strings can be lexicographically compared using the ==, !=, >, <, >= and
  /// <= operators.
  bool operator >(RulesString other);

  /// Strings can be lexicographically compared using the ==, !=, >, <, >= and
  /// <= operators.
  bool operator <(RulesString other);

  /// Strings can be lexicographically compared using the ==, !=, >, <, >= and
  /// <= operators.
  bool operator >=(RulesString other);

  /// Strings can be lexicographically compared using the ==, !=, >, <, >= and
  /// <= operators.
  bool operator <=(RulesString other);

  /// Strings can be concatenated using the + operator:
  RulesString operator +(RulesString other);

  /// Sub-strings can be accessed using the index operator [].
  RulesString operator [](int index);

  /// They can also be accessed using the range operator [i:j]. Note that
  /// parameter j, the upper bound in the range operator, is not inclusive.
  RulesString range(int i, int j);

  /// Returns a lowercase version of the input string.
  RulesString lower();

  /// Performs a regular expression match on the whole string.
  bool matches(RulesString regex);

  /// Replaces all occurrences of substrings matching a regular expression with
  /// a user-supplied string.
  RulesString replace(RulesString re, RulesString sub);

  /// Returns the number of characters in the string.
  int size();

  /// Splits a string according to a regular expression.
  List<RulesString> split(RulesString re);

  /// Returns the UTF-8 byte encoding of a string.
  RulesBytes toUtf8();

  /// Returns a version of the string with leading and trailing spaces removed.
  RulesString trim();

  /// Returns an uppercase version of the input string.
  RulesString upper();
}
