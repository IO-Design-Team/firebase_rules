import 'package:firebase_rules/src/firebase/namespace/model/model.dart';
import 'package:firebase_rules/src/firebase/service/base.dart';
import 'package:meta/meta_meta.dart';
import 'package:meta/meta.dart';

/// Firebase Rules annotation
@Target({TargetKind.topLevelVariable})
@immutable
class FirebaseRules {
  /// The rules version. Defaults to 2.
  final String rulesVersion;

  /// The firebase service these rules are for
  final Service service;

  /// Functions used in these rules
  final List<Function> functions;

  /// Maps of enums to their string values for code generation
  final List<Map<Enum, String>> enums;

  /// Constructor
  const FirebaseRules({
    this.rulesVersion = '2',
    required this.service,
    this.functions = const [],
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
@immutable
class Allow {
  /// Permitted operations
  final List<Operation> operations;

  /// The condition that allows [operations] to be prefromed
  final bool condition;

  /// Constructor
  const Allow(this.operations, this.condition);
}

/// Base class used for analysis
abstract class FirebaseMatch {}

/// A firebase rules match statement
@immutable
class Match<T extends FirebaseResource> extends FirebaseMatch {
  /// The Firebase path
  ///
  /// One `{wildcard}` is allowed per path
  final String path;

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
  Match(this.path, {this.rules, this.matches});
}
