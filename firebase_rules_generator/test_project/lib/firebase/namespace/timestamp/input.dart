// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test(RulesTimestamp one, RulesDuration two) {
  final a = rules.timestamp.date(0, 0, 0);
  final b = rules.timestamp.value(0);
  final c = one + two;
  final d = one - two;
  final e = one.date();
  final f = one.day();
  final g = one.dayOfWeek();
  final h = one.dayOfYear();
  final i = one.hours();
  final j = one.minutes();
  final k = one.month();
  final l = one.nanos();
  final m = one.seconds();
  final n = one.time();
  final o = one.toMillis();
  final p = one.year();
  return true;
}

@FirebaseRules(service: Service.firestore, functions: [test])
final firestoreRules = <Match>[];
