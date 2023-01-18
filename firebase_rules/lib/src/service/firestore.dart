import 'package:firebase_rules/firebase_rules.dart';

/// Base firestore path
class FirestorePath extends FirebasePath {
  /// The raw path used by code generation
  static const rawPath = '/databases/{database}/documents';

  /// The current database
  String get database => throw UnimplementedError();

  @override
  String get path => rawPath.replaceFirst('{database}', database);
}
