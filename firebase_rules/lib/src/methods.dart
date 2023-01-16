import 'package:firebase_rules/src/model/bytes.dart';
import 'package:firebase_rules/src/model/duration.dart';
import 'package:firebase_rules/src/model/lat_lng.dart';
import 'package:firebase_rules/src/model/timestamp.dart';
import 'package:firebase_rules/src/rules_type.dart';

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
T debug<T>(T value) => throw UnimplementedError();

/// Globally available duration functions. These functions are accessed using
/// the duration. prefix.
abstract class DurationMethods extends RulesType {
  DurationMethods._();

  /// Absolute value of a duration.
  Duration abs();

  /// Create a duration from hours, minutes, seconds, and nanoseconds.
  Duration time(int hours, int minutes, int secs, int nanos);

  /// Create a duration from a numeric magnitude and string unit.
  Duration value(int magnitude, DurationUnit unit);
}

/// Access to [DurationMethods]
DurationMethods get duration => throw UnimplementedError();

/// Context specific variables and methods for Cloud Firestore security rules.
abstract class FirestoreMethods extends RulesType {
  FirestoreMethods._();

  // TODO: Inject database base path into these

  /// Check if a document exists.
  bool exists(String path) => throw UnimplementedError();

  /// Check if a document exists, assuming the current request succeeds.
  /// Equivalent to getAfter(path) != null.
  bool existsAfter(String path) => throw UnimplementedError();

  /// Get the contents of a firestore document.
  T get<T>(String path) => throw UnimplementedError();

  /// Get the projected contents of a document. The document is returned as if the
  /// current request had succeeded. Useful for validating documents that are part
  /// of a batched write or transaction.
  T getAfter<T>(String path) => throw UnimplementedError();
}

/// Access to [FirestoreMethods]
FirestoreMethods get firestore => throw UnimplementedError();

/// Globally available hashing functions. These functions are accessed using
/// the hashing. prefix.
abstract class HashingMethods extends RulesType {
  HashingMethods._();

  /// Compute a hash using the CRC32 algorithm.
  Bytes crc32(dynamic input);

  /// Compute a hash using the CRC32C algorithm.
  Bytes crc32c(dynamic input);

  /// Compute a hash using the MD5 algorithm.
  Bytes md5(dynamic input);

  /// Compute a hash using the SHA-256 algorithm.
  Bytes sha256(dynamic input);
}

/// Access to [HashingMethods]
HashingMethods get hashing => throw UnimplementedError();

/// Globally available latitude-longitude functions. These functions are
/// accessed using the latlng. prefix
abstract class LatLngMethods extends RulesType {
  LatLngMethods._();

  /// Create a LatLng from floating point coordinates.
  LatLng value(double lat, double lng);
}

/// Access to [LatLngMethods]
LatLngMethods get latlng => throw UnimplementedError();

/// Globally available mathematical functions. These functions are accessed
/// using the math. prefix and operate on numerical values.
abstract class MathMethods extends RulesType {
  MathMethods._();

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

/// Access to [MathMethods]
MathMethods get math => throw UnimplementedError();

/// Globally available timestamp functions. These functions are accessed using
/// the timestamp. prefix.
abstract class TimestampMethods extends RulesType {
  TimestampMethods._();

  /// Make a timestamp from a year, month, and day.
  Timestamp date(int year, int month, int day);

  /// Make a timestamp from an epoch time in milliseconds.
  Timestamp value(int epochMillis);
}

/// Access to [TimestampMethods]
TimestampMethods get timestamp => throw UnimplementedError();
