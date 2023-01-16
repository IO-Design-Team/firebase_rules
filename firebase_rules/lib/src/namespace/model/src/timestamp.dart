import 'package:firebase_rules/src/namespace/model/model.dart';
import 'package:firebase_rules/src/rules_type.dart';

/// A timestamp in UTC with nanosecond accuracy.
abstract class RulesTimestamp extends RulesType {
  RulesTimestamp._();

  /// Add a duration to this timestamp
  operator +(RulesDuration duration);

  /// Subtract a duration from this timestamp
  operator -(RulesDuration duration);

  /// Timestamp value containing year, month, and day only.
  RulesTimestamp date();

  /// Get the day value of the timestamp.
  int day();

  /// Get the day of the week as a value from 1 to 7.
  int dayOfWeek();

  /// Get the day of the year as a value from 1 to 366.
  int dayOfYear();

  /// Get the hours value of the timestamp.
  int hours();

  /// Get the minutes value of the timestamp.
  int minutes();

  /// Get the month value of the timestamp.
  int month();

  /// Get the nanos value of the timestamp.
  int nanos();

  /// Get the seconds value of the timestamp.
  int seconds();

  /// Get the duration value from the time portion of the timestamp.
  RulesDuration time();

  /// Get the time in milliseconds since the epoch.
  int toMillis();

  /// Get the year value of the timestamp.
  int year();
}
