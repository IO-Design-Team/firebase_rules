// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test(RulesDuration other) {
  final a = other.nanos();
  final b = other.seconds();
  final c = rules.duration.abs(other);
  final d = rules.duration.time(0, 0, 0, 0);
  final e = rules.duration.value(0, RulesDurationUnit.weeks);
  final f = rules.duration.value(0, RulesDurationUnit.days);
  final g = rules.duration.value(0, RulesDurationUnit.hours);
  final h = rules.duration.value(0, RulesDurationUnit.minutes);
  final i = rules.duration.value(0, RulesDurationUnit.seconds);
  final j = rules.duration.value(0, RulesDurationUnit.milliseconds);
  final k = rules.duration.value(0, RulesDurationUnit.nanoseconds);

  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];
