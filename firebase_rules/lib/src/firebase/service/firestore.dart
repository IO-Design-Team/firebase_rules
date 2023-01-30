import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules/src/firebase/service/base.dart';

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

  /// Allows access to '__name__' property
  RulesPath get firestoreResourceName;

  /// Map of the document data.
  T get data;

  /// String of the document's key
  RulesString get id;
}
