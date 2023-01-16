import 'dart:typed_data';

import 'package:firebase_rules/src/rules_type.dart';

/// Type representing a sequence of bytes.
abstract class Bytes extends RulesType {
  Bytes._();

  /// Returns the number of bytes in a Bytes sequence.
  int size();

  /// Returns the Base64-encoded string corresponding to the provided Bytes
  /// sequence.
  ///
  /// Base64 encoding is performed per the base64url specification.
  String toBase64();

  /// Returns the hexadecimal-encoded string corresponding to the provided Bytes
  /// sequence.
  String toHexString();
}

/// Create bytes from string
// TODO: Convert to string literal
Bytes bytes(String value) => throw UnimplementedError();

/// Access to [Bytes] methods
extension BytesExtension on Uint8List {
  /// Access to [Bytes] methods
  Bytes get rulesType => throw UnimplementedError();
}
