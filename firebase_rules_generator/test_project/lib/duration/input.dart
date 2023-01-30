// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase_rules.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

@RulesFunction()
bool test(RulesDuration dur) {
  final a = dur.nanos();
  final b = dur.seconds();
  final c = rules.duration.abs(dur);
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

@FirebaseRules(service: Service.firestore)
final firestoreRules = <Match>[];

abstract class BlobTest {
  Blob get blob;
}
