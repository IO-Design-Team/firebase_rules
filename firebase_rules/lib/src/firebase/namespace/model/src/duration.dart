/// Duration with nanosecond accuracy.
abstract class RulesDuration {
  RulesDuration._();

  /// Get the nanoseconds portion (signed) of the duration from -999,999,999 to
  /// +999,999,999 inclusive.
  int nanos();

  /// Get the seconds portion (signed) of the duration from -315,576,000,000 to
  /// +315,576,000,000 inclusive.
  int seconds();
}

/// Unit of the duration.
enum RulesDurationUnit {
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
      case RulesDurationUnit.weeks:
        return 'w';
      case RulesDurationUnit.days:
        return 'd';
      case RulesDurationUnit.hours:
        return 'h';
      case RulesDurationUnit.minutes:
        return 'm';
      case RulesDurationUnit.seconds:
        return 's';
      case RulesDurationUnit.milliseconds:
        return 'ms';
      case RulesDurationUnit.nanoseconds:
        return 'ns';
    }
  }
}
