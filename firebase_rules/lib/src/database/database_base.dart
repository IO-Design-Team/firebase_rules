import 'package:firebase_rules/src/database/rule_data_snapshot.dart';
import 'package:meta/meta_meta.dart';

/// Database Rules annotation
@Target({TargetKind.topLevelVariable})
class DatabaseRules {
  /// Constructor
  const DatabaseRules();
}

/// A callback that provides information about the current rules context
typedef ContextualCallback<T, V> = T Function(
  String location,
  RulesContext<V> context,
);

/// Database rules base path
const basePath = 'rules';

/// Database match statement

class Match<U> {
  /// The path
  ///
  /// One `$location` wild card is allowed at the end of the path. Path
  /// segments will be expanded automatically.
  final String path;

  /// Read
  final ContextualCallback<bool, U>? read;

  /// Write
  final ContextualCallback<bool, U>? write;

  /// Validate
  final ContextualCallback<bool, U>? validate;

  /// Index on
  final List<String>? indexOn;

  /// Matches
  final ContextualCallback<List<Match>, U>? matches;

  /// Constructor
  Match(
    this.path, {
    this.read,
    this.write,
    this.validate,
    this.indexOn,
    this.matches,
  });
}

/// Rules context
abstract class RulesContext<T> {
  // TODO
  dynamic get auth;

  /// Contains the number of milliseconds since the Unix epoch according to the
  /// Firebase Realtime Database servers.
  int get now;

  /// A RuleDataSnapshot corresponding to the current data at the root of your
  /// Firebase Realtime Database.
  RuleDataSnapshot get root;

  /// A RuleDataSnapshot corresponding to the current data in Firebase Realtime
  /// Database at the location of the currently executing rule.
  RuleDataSnapshot get data;

  /// A RuleDataSnapshot corresponding to the data that will result if the write
  /// is allowed.
  RuleDataSnapshot get newData;
}
