import 'package:firebase_rules/src/namespace/model/model.dart';
import 'package:firebase_rules/src/rules_type.dart';

/// Type representing a sequence of bytes.
abstract class RulesBytes extends RulesType {
  RulesBytes._();

  /// Returns the number of bytes in a Bytes sequence.
  int size();

  /// Returns the Base64-encoded string corresponding to the provided Bytes
  /// sequence.
  ///
  /// Base64 encoding is performed per the base64url specification.
  RulesString toBase64();

  /// Returns the hexadecimal-encoded string corresponding to the provided Bytes
  /// sequence.
  RulesString toHexString();
}