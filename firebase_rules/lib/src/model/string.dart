import 'package:firebase_rules/src/model/bytes.dart';
import 'package:firebase_rules/src/rules_type.dart';

/// Primitive type representing a string value.
abstract class String extends RulesType {
  String._();

  /// Sub-strings can be accessed using the index operator [].
  String operator [](int index);

  /// They can also be accessed using the range operator [i:j]. Note that
  /// parameter j, the upper bound in the range operator, is not inclusive.
  String range(int i, int j);

  /// Returns a lowercase version of the input string.
  String lower();

  /// Performs a regular expression match on the whole string.
  bool matches(String regex);

  /// Replaces all occurrences of substrings matching a regular expression with
  /// a user-supplied string.
  String replace(String re, String sub);

  /// Returns the number of characters in the string.
  int size();

  /// Splits a string according to a regular expression.
  List<String> split(String re);

  /// Returns the UTF-8 byte encoding of a string.
  Bytes toUtf8();

  /// Returns a version of the string with leading and trailing spaces removed.
  String trim();

  /// Returns an uppercase version of the input string.
  String upper();
}

/// Boolean, integer, float, and null values can be converted into strings
/// using the string() function:
String string(Object? value) => throw UnimplementedError();

/// Access to [String] methods
extension StringExtension on String {
  /// Access to [String] methods
  String get rulesType => throw UnimplementedError();
}
