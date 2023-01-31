// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test() {
  final a = rules.math.abs(0);
  final b = rules.math.ceil(0);
  final c = rules.math.floor(0);
  final d = rules.math.isInfinite(0);
  final e = rules.math.isNaN(0);
  final f = rules.math.pow(0, 0);
  final g = rules.math.round(0);
  return true;
}

@FirebaseRules(service: Service.firestore, functions: [test])
final firestoreRules = <Match>[];
