/// Duration with nanosecond accuracy.
abstract class Duration {
  Duration._();

  /// Absolute value of a duration.
  Duration abs();

  /// Create a duration from hours, minutes, seconds, and nanoseconds.
  Duration time(int hours, int minutes, int secs, int nanos);

  /// Create a duration from a numeric magnitude and string unit.
  Duration value(int magnitude, DurationUnit unit);

  /// Get the nanoseconds portion (signed) of the duration from -999,999,999 to
  /// +999,999,999 inclusive.
  int nanos();

  /// Get the seconds portion (signed) of the duration from -315,576,000,000 to
  /// +315,576,000,000 inclusive.
  int seconds();
}

Duration get duration => throw UnimplementedError();

/// Unit of the duration.
enum DurationUnit {
  /// Weeks
  weeks,

  /// Days
  days,

  /// Hours
  hours,

  /// Minutes
  minutes,

  /// Seconds
  seconds,

  /// Milliseconds
  milliseconds,

  /// Nanoseconds
  nanoseconds;

  @override
  String toString() {
    switch (this) {
      case DurationUnit.weeks:
        return 'w';
      case DurationUnit.days:
        return 'd';
      case DurationUnit.hours:
        return 'h';
      case DurationUnit.minutes:
        return 'm';
      case DurationUnit.seconds:
        return 's';
      case DurationUnit.milliseconds:
        return 'ms';
      case DurationUnit.nanoseconds:
        return 'ns';
    }
  }
}
