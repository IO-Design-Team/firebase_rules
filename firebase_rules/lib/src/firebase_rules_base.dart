import 'package:firebase_rules/model.dart' as rules;
import 'package:meta/meta_meta.dart';

@Target({TargetKind.topLevelVariable})
class FirebaseRules {
  final String rulesVersion;
  final Service service;

  /// Constructor
  const FirebaseRules({
    this.rulesVersion = '2',
    required this.service,
  });
}

enum Service {
  firestore,
  storage;

  @override
  String toString() {
    switch (this) {
      case Service.firestore:
        return 'cloud.firestore';
      case Service.storage:
        return 'firebase.storage';
    }
  }
}

/// A callback that provides information about the current rules context
typedef ContextualCallback<T, U extends Path, V> = List<T> Function(
  U path,
  rules.Request<V> request,
  rules.Resource<V> resource,
);

abstract class Path {
  String get path;
}

enum Operation {
  read,
  write,
  get,
  list,
  create,
  update,
  delete,
}

class Rule {
  List<Operation> operations;
  bool condition;

  Rule(this.operations, this.condition);
}

class Match<T extends Path, U> {
  final ContextualCallback<Rule, T, U>? rules;
  final ContextualCallback<Match, T, U>? matches;

  Match({this.rules, this.matches});
}

bool raw(String expression) => throw UnimplementedError();
