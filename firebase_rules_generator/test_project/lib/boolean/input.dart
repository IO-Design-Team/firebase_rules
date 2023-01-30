// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase_rules.dart';

@RulesFunction()
bool test() {
  final a = rules.parseBool('true'.rules);
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = <Match>[];
