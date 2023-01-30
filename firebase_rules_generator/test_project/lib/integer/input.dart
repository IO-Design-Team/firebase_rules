// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase_rules.dart';

@RulesFunction()
bool test() {
  final a = rules.parseInt('2'.rules);
  final b = rules.parseInt(2.0);
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = <Match>[];
