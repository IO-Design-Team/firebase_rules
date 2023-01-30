// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

@RulesFunction()
bool test(RulesString one, RulesString two) {
  final a = one > two;
  final b = one < two;
  final c = one >= two;
  final d = one <= two;
  final e = one + two;
  final f = one[0];
  final g = one.range(0, 1);
  final h = rules.string(true);
  final i = rules.string(1);
  final j = rules.string(2.0);
  final k = rules.string(null);
  final l = one.lower();
  final m = one.matches('.*@domain[.]com'.rules);
  final n = one.replace('a'.rules, 'b'.rules);
  final o = one.size();
  final p = one.split('/'.rules);
  final q = '€'.rules.toUtf8() == rules.parseBytes(r'\xE2\x82\xAC'.rules);
  final r = one.trim();
  final s = one.upper();
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = <Match>[];
