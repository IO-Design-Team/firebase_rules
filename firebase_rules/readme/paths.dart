import 'package:firebase_rules/firebase.dart';

/// Path classes should be `abstract` and extend [FirebasePath]. Since this
/// code isn't actually going to run, implementations are unnecessary.
abstract class UsersPath extends FirebasePath {
  /// Path parameters should be strings
  String get userId;

  /// Create a path using literals and interpolate the path parameters. The
  /// generator will convert this to a firebase path.
  @override
  String get path => '/users/$userId';
}

abstract class User {
  String get userId;
}
