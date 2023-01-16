/// Type representing a sequence of bytes.
abstract class Bytes {
  Bytes._();

  /// Returns the number of bytes in a Bytes sequence.
  int size() => throw UnimplementedError();

  /// Returns the Base64-encoded string corresponding to the provided Bytes
  /// sequence.
  ///
  /// Base64 encoding is performed per the base64url specification.
  String toBase64() => throw UnimplementedError();

  /// Returns the hexadecimal-encoded string corresponding to the provided Bytes
  /// sequence.
  String toHexString() => throw UnimplementedError();
}

/// Extension to access [Bytes] methods
extension BytesExtension<T> on T {
  /// Access to [Bytes] methods
  Bytes asBytes() => throw UnimplementedError();
}
