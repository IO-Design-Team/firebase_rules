import 'package:firebase_rules/firebase_rules.dart';
import 'package:firebase_rules/src/service/base.dart';

/// Base firestore path
abstract class FirestorePath extends FirebasePath {
  /// The raw path used by code generation
  static const rawPath = '/databases/{database}/documents';

  /// The current database
  String get database;

  @override
  String get path => rawPath.replaceFirst('{database}', database);
}

/// A firebase resource object
abstract class FirestoreResource<T> extends FirebaseResource {
  FirestoreResource._();

  /// The full document name, as a path.
  RulesString get name;

  /// Map of the document data.
  T get data;

  /// String of the document's key
  RulesString get key;
}
