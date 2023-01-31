// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test(RulesList<String> list, RulesList<String> other) {
  final a = list[0];
  final b = list.range(0, 1);
  final c = ['a', 'b'].rules.contains('a');
  final d = list.contains('a');
  final e = ['a', 'b'].rules.range(0, 1);
  final f = list.range(0, 1);
  final g = list.concat(other);
  final h = list.hasAll(other);
  final i = list.hasAny(other);
  final j = list.hasOnly(other);
  final k = list.join(','.rules);
  final l = list.removeAll(other);
  final m = list.size();
  final n = list.toSet();
  return true;
}

@FirebaseRules(service: Service.firestore, functions: [test])
final firestoreRules = <Match>[];
