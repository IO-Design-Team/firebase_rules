import 'package:firebase_rules/src/namespace/model/model.dart';
import 'package:meta/meta_meta.dart';

/// Firebase Rules annotation
@Target({TargetKind.topLevelVariable})
class FirebaseRules {
  /// The rules version. Defaults to 2.
  final String rulesVersion;

  /// The firebase service these rules are for
  final Service service;

  /// If true, print debug information
  final bool debug;

  /// Constructor
  const FirebaseRules({
    this.rulesVersion = '2',
    required this.service,
    this.debug = false,
  });
}

/// Firebase Rules function annotation
@Target({TargetKind.function})
class RulesFunction {
  /// Constructor
  const RulesFunction();
}

/// Firebase rules services
enum Service {
  /// Firestore
  firestore,

  /// Storage
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
typedef ContextualCallback<T, U extends FirebasePath, V> = List<T> Function(
  U path,
  RulesRequest<V> request,
  RulesResource<V> resource,
);

/// A service path that provides access to path parameters
abstract class FirebasePath {
  /// The path string for code generation
  String get path;
}

/// Service operations
enum Operation {
  /// Read
  read,

  /// Write
  write,

  /// Get
  get,

  /// List
  list,

  /// Create
  create,

  /// Update
  update,

  /// Delete
  delete,
}

/// A firebase rule
class Rule {
  /// Permitted operations
  final List<Operation> operations;

  /// The condition that allows [operations] to be prefromed
  final bool condition;

  /// Constructor
  Rule(this.operations, this.condition);
}

/// A firebase rules match statement
class Match<T extends FirebasePath, U> {
  /// Rules for this context
  final ContextualCallback<Rule, T, U>? rules;

  /// Nested matches for this context
  final ContextualCallback<Match, T, U>? matches;

  /// Constructor
  Match({this.rules, this.matches});
}
