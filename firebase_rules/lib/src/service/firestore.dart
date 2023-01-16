import 'package:firebase_rules/firebase_rules.dart';

/// Base firestore path
class FirestorePath extends Path {
  /// The current database
  String get database => throw UnimplementedError();

  @override
  String get path => '/databases/$database/documents';
}
