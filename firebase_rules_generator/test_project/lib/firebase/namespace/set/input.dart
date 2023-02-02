// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test() {
  final a = ['a', 'b'].rules().toSet().contains('a') == true;
  final b = ['a', 'b'].rules().toSet().difference(['a', 'c'].rules().toSet()) ==
      ['b'].rules().toSet();
  final c =
      ['a', 'b'].rules().toSet().hasAll(['a', 'c'].rules().toSet()) == false;
  final d =
      ['d', 'e', 'f'].rules().toSet().hasAll(['d', 'e'].rules().toSet()) ==
          true;
  final e =
      ['a', 'b'].rules().toSet().hasAny(['c', 'd'].rules().toSet()) == false;
  final f =
      ['a', 'b'].rules().toSet().hasAny(['a', 'c'].rules().toSet()) == true;
  final g =
      ['a', 'b'].rules().toSet().hasOnly(['a', 'c'].rules().toSet()) == false;
  final h =
      ['a', 'b'].rules().toSet().hasOnly(['a', 'b'].rules().toSet()) == true;
  final i =
      ['a', 'b'].rules().toSet().intersection(['a', 'c'].rules().toSet()) ==
          ['a'].rules().toSet();
  final j = ['a', 'b'].rules().toSet().size() == 2;
  final k = ['a', 'b'].rules().toSet().union(['a', 'c'].rules().toSet()) ==
      ['a', 'b', 'c'].rules().toSet();
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot, functions: [test]),
];
