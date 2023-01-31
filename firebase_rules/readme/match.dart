import 'package:firebase_rules/firebase.dart';
import 'paths.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  /// Always start with this match. [FirestorePath] is the root of Firestore.
  Match<FirestorePath, FirestoreResource>(
    /// Match statements give access to type-safe contextual information:
    /// - [path] is the path class of this match
    /// - [request] gives access to the [Request] object
    /// - [resource] gives access to the [Resource] object
    /// 
    /// The [path] parameter can have any name, but [request] and [resource]
    /// must not  be renamed
    matches: (path, request, resource) => [
      /// Subsequent matches should use typed [FirestoreResource] objects.
      /// This makes the [request] and [resource] parameters type-safe.
      Match<UsersPath, FirestoreResource<User>>(),
    ],
  ),
];

@FirebaseRules(service: Service.storage)
final storageRules = [
  /// Always start with this match. [StoragePath] is the root of Storage.
  Match<StoragePath, StorageResource>(
    matches: (path, request, resource) => [
      /// All storage matches use [StorageResource] objects
      Match<UsersPath, StorageResource>(),
    ],
  ),
];
