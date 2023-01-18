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
typedef ContextualCallback<T, U extends FirebasePath, V> = T Function(
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
  final ContextualCallback<MatchBody, T, U> body;

  /// Constructor
  Match(this.body);
}

/// The body of a match
class MatchBody {
  /// The rules in this [MatchBody]
  final List<Rule>? rules;

  /// The nested matches in this [MatchBody]
  final List<Match>? matches;

  /// Constructor
  MatchBody({this.rules, this.matches});
}

/// A raw rules string if type-safe code is impractical
///
/// Avoid if possible
bool raw(String expression) => throw UnimplementedError();
