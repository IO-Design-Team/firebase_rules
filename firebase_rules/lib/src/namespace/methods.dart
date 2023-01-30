import 'package:firebase_rules/src/namespace/model/model.dart';

/// Globally available duration functions. These functions are accessed using
/// the duration. prefix.
abstract class RulesDurationMethods {
  RulesDurationMethods._();

  /// Absolute value of a duration.
  RulesDuration abs(RulesDuration duration);

  /// Create a duration from hours, minutes, seconds, and nanoseconds.
  RulesDuration time(int hours, int minutes, int secs, int nanos);

  /// Create a duration from a numeric magnitude and string unit.
  RulesDuration value(int magnitude, RulesDurationUnit unit);
}

/// Context specific variables and methods for Cloud Firestore security rules.
abstract class RulesFirestoreMethods {
  RulesFirestoreMethods._();

  /// Check if a document exists.
  bool exists(RulesString path);

  /// Check if a document exists, assuming the current request succeeds.
  /// Equivalent to getAfter(path) != null.
  bool existsAfter(RulesString path);

  /// Get the contents of a firestore document.
  T get<T>(RulesString path);

  /// Get the projected contents of a document. The document is returned as if the
  /// current request had succeeded. Useful for validating documents that are part
  /// of a batched write or transaction.
  T getAfter<T>(RulesString path);
}

/// Globally available hashing functions. These functions are accessed using
/// the hashing. prefix.
abstract class RulesHashingMethods {
  RulesHashingMethods._();

  /// Compute a hash using the CRC32 algorithm.
  RulesBytes crc32(dynamic input);

  /// Compute a hash using the CRC32C algorithm.
  RulesBytes crc32c(dynamic input);

  /// Compute a hash using the MD5 algorithm.
  RulesBytes md5(dynamic input);

  /// Compute a hash using the SHA-256 algorithm.
  RulesBytes sha256(dynamic input);
}

/// Globally available latitude-longitude functions. These functions are
/// accessed using the latlng. prefix
abstract class RulesLatLngMethods {
  RulesLatLngMethods._();

  /// Create a LatLng from floating point coordinates.
  RulesLatLng value(double lat, double lng);
}

/// Globally available mathematical functions. These functions are accessed
/// using the math. prefix and operate on numerical values.
abstract class RulesMathMethods {
  RulesMathMethods._();

  /// Absolute value of a numeric value.
  num abs(num value);

  /// Ceiling of the numeric value.
  int ceil(num value);

  /// Floor of the numeric value.
  int floor(num value);

  /// Test whether the value is ±∞.
  bool isInfinite(num value);

  /// Test whether the value is NaN.
  bool isNaN(num value);

  /// Return the value of the first argument raised to the power of the second
  /// argument.
  double pow(num base, num exponent);

  /// Round the input value to the nearest int.
  int round(num value);

  /// Square root of the input value.
  double sqrt(num value);
}

/// Globally available timestamp functions. These functions are accessed using
/// the timestamp. prefix.
abstract class RulesTimestampMethods {
  RulesTimestampMethods._();

  /// Make a timestamp from a year, month, and day.
  RulesTimestamp date(int year, int month, int day);

  /// Make a timestamp from an epoch time in milliseconds.
  RulesTimestamp value(int epochMillis);
}

/// Globally available rules functions
abstract class RulesMethods {
  RulesMethods._();

  /// Strings can be converted into booleans using the bool() function:
  bool parseBool(RulesString value);

  /// Create bytes from string
  RulesBytes parseBytes(RulesString value);

  /// String and integer values can be converted to float values using the float()
  /// function:
  double parseFloat(Object value);

  /// String and float values can be converted to integers using the int()
  /// function:
  int parseInt(Object value);

  /// Boolean, integer, float, and null values can be converted into strings
  /// using the string() function:
  RulesString string(Object? value);

  /// A basic debug function that prints Security Rules language objects,
  /// variables and statement results as they are being evaluated by the Security
  /// Rules engine. The outputs of debug are written to firestore-debug.log.
  ///
  /// The debug function can only be called inside Rules conditions.
  ///
  /// debug function blocks are only executed by the Security Rules engine in the
  /// Firestore emulator, part of the Firebase Emulator Suite. The debug function
  /// has no effect in production.
  ///
  /// Debug logfile entries are prepended by a string identifying the Rules
  /// language data type of the log output (for example, string_value, map_value).
  ///
  /// Calls to debug can be nested.
  ///
  /// Currently, the debug feature does not support the concept of logging levels
  /// (for example, INFO, WARN, ERROR).
  T debug<T>(T value);

  /// A raw rules string if type-safe code is impractical
  ///
  /// Avoid if possible
  // TODO: Remove?
  bool raw(String expression) => throw UnimplementedError();

  /// Access to [RulesDurationMethods]
  RulesDurationMethods get duration;

  /// Access to [RulesFirestoreMethods]
  RulesFirestoreMethods get firestore;

  /// Access to [RulesHashingMethods]
  RulesHashingMethods get hashing;

  /// Access to [RulesLatLngMethods]
  RulesLatLngMethods get latlng;

  /// Access to [RulesMathMethods]
  RulesMathMethods get math;

  /// Access to [RulesTimestampMethods]
  RulesTimestampMethods get timestamp;
}

/// Access to [RulesMethods]
RulesMethods get rules => throw UnimplementedError();
