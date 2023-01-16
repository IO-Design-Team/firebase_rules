import 'package:firebase_rules/model.dart' as rules;
import 'package:meta/meta_meta.dart';

/// Firebase Rules annotation
@Target({TargetKind.topLevelVariable})
class FirebaseRules {
  /// The rules version. Defaults to 2.
  final String rulesVersion;

  /// The firebase service these rules are for
  final Service service;

  /// Constructor
  const FirebaseRules({
    this.rulesVersion = '2',
    required this.service,
  });
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
typedef ContextualCallback<T, U extends Path, V> = List<T> Function(
  U path,
  rules.Request<V> request,
  rules.Resource<V> resource,
);

/// A service path that provides access to path parameters
abstract class Path {
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
  List<Operation> operations;

  /// The condition that allows [operations] to be prefromed
  bool condition;

  /// Constructor
  Rule(this.operations, this.condition);
}

/// A firebase rules match statement
class Match<T extends Path, U> {
  /// Rules for this context
  final ContextualCallback<Rule, T, U>? rules;

  /// Nested matches for this context
  final ContextualCallback<Match, T, U>? matches;

  /// Constructor
  Match({this.rules, this.matches});
}

/// A raw rules string if type-safe code is impractical
bool raw(String expression) => throw UnimplementedError();
