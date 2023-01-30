import 'package:firebase_rules/database.dart';
import 'package:meta/meta_meta.dart';

/// Database Rules annotation
@Target({TargetKind.topLevelVariable})
class DatabaseRules {
  /// Constructor
  const DatabaseRules();
}

/// A callback that provides information about the current rules context
typedef ContextualCallback<T> = T Function(String location);

/// Database rules base path
const basePath = 'rules';

/// Database match statement

class Match {
  /// The path
  ///
  /// One `$location` wild card is allowed at the end of the path. Path
  /// segments will be expanded automatically.
  final String path;

  /// Read
  final ContextualCallback<bool>? read;

  /// Write
  final ContextualCallback<bool>? write;

  /// Validate
  final ContextualCallback<bool>? validate;

  /// Index on
  final List<String>? indexOn;

  /// Matches
  final ContextualCallback<List<Match>>? matches;

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

/// A variable containing the token payload if a client is authenticated, or
/// null if the client isn't authenticated.
RulesAuth? get auth => throw UnimplementedError();

/// Contains the number of milliseconds since the Unix epoch according to the
/// Firebase Realtime Database servers.
int get now => throw UnimplementedError();

/// A RuleDataSnapshot corresponding to the current data at the root of your
/// Firebase Realtime Database.
RuleDataSnapshot get root => throw UnimplementedError();

/// A RuleDataSnapshot corresponding to the current data in Firebase Realtime
/// Database at the location of the currently executing rule.
RuleDataSnapshot get data => throw UnimplementedError();

/// A RuleDataSnapshot corresponding to the data that will result if the write
/// is allowed.
RuleDataSnapshot get newData => throw UnimplementedError();
