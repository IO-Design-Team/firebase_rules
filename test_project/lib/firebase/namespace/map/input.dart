// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test(RulesMap<String, int> other) {
  final a = {'a': 2}.rules().contains('a');
  final b = other.contains('a');
  final c = other.diff({'a': 2}.rules()).addedKeys();
  final d = other.diff({'a': 2}.rules()).affectedKeys();
  final e = other.diff({'a': 2}.rules()).changedKeys();
  final f = other.diff({'a': 2}.rules()).removedKeys();
  final g = other.diff({'a': 2}.rules()).unchangedKeys();
  final h = other.get('a', 4);
  final i = other.keys();
  final j = other.size();
  final k = other.values();
  final l = !other.contains('a');
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot, functions: [test]),
];
