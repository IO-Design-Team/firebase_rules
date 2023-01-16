import 'package:firebase_rules/src/rules_type.dart';

/// Duration with nanosecond accuracy.
abstract class Duration extends RulesType {
  Duration._();

  /// Get the nanoseconds portion (signed) of the duration from -999,999,999 to
  /// +999,999,999 inclusive.
  int nanos();

  /// Get the seconds portion (signed) of the duration from -315,576,000,000 to
  /// +315,576,000,000 inclusive.
  int seconds();
}

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
