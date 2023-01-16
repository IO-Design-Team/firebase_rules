import 'dart:core' as core;

import 'package:firebase_rules/src/namespace/model/duration.dart';
import 'package:firebase_rules/src/rules_type.dart';

/// A timestamp in UTC with nanosecond accuracy.
abstract class Timestamp extends RulesType {
  Timestamp._();

  /// Add a duration to this timestamp
  operator +(Duration duration);

  /// Subtract a duration from this timestamp
  operator -(Duration duration);

  /// Timestamp value containing year, month, and day only.
  Timestamp date();

  /// Get the day value of the timestamp.
  core.int day();

  /// Get the day of the week as a value from 1 to 7.
  core.int dayOfWeek();

  /// Get the day of the year as a value from 1 to 366.
  core.int dayOfYear();

  /// Get the hours value of the timestamp.
  core.int hours();

  /// Get the minutes value of the timestamp.
  core.int minutes();

  /// Get the month value of the timestamp.
  core.int month();

  /// Get the nanos value of the timestamp.
  core.int nanos();

  /// Get the seconds value of the timestamp.
  core.int seconds();

  /// Get the duration value from the time portion of the timestamp.
  Duration time();

  /// Get the time in milliseconds since the epoch.
  core.int toMillis();

  /// Get the year value of the timestamp.
  core.int year();
}
