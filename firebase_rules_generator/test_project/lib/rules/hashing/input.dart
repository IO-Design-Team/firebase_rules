// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase_rules.dart';

@RulesFunction()
bool test(FirestoreResource resource) {
  final a = rules.hashing.crc32('asdf');
  final b = rules.hashing.crc32c('asdf');
  final c = rules.hashing.md5('asdf');
  final d = rules.hashing.sha256('asdf');
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = <Match>[];
