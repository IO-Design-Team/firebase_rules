import 'package:firebase_rules/src/firebase/namespace/model/model.dart';
import 'package:firebase_rules/src/firebase/service/base.dart';
import 'package:meta/meta_meta.dart';

/// Firebase Rules annotation
@Target({TargetKind.topLevelVariable})
class FirebaseRules {
  /// The rules version. Defaults to 2.
  final String rulesVersion;

  /// The firebase service these rules are for
  final Service service;

  /// Maps of enums to their string values for code generation
  final List<Map<Enum, String>> enums;

  /// Constructor
  const FirebaseRules({
    this.rulesVersion = '2',
    required this.service,
    this.enums = const [],
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
typedef ContextualCallback<T, U extends FirebaseResource> = List<T> Function(
  RulesString _,
  RulesRequest<U> request,
  U resource,
);

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

/// A firebase allow rule
class Allow {
  /// Permitted operations
  final List<Operation> operations;

  /// The condition that allows [operations] to be prefromed
  final bool condition;

  /// Constructor
  Allow(this.operations, this.condition);
}

/// A firebase rules match statement
class Match<T extends FirebaseResource> {
  /// The Firebase path
  ///
  /// One `{wildcard}` is allowed per path
  final String path;

  /// Functions to place in this context
  final List<Function>? functions;

  /// Rules for this context
  ///
  /// The [path] parameter name must match the name of the wildcard.
  /// The [request] and [resource] parameters must not  be renamed.
  final ContextualCallback<Allow, T>? rules;

  /// Nested matches for this context
  ///
  /// The [path] parameter name must match the name of the wildcard.
  /// The [request] and [resource] parameters must not  be renamed.
  final ContextualCallback<Match, T>? matches;

  /// Constructor
  Match(this.path, {this.functions, this.rules, this.matches});
}
