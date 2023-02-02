import 'package:firebase_rules/firebase.dart';
import 'shared.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  /// Always start with this match. [firestoreRoot] is the root of Firestore.
  Match<FirestoreResource>(
    firestoreRoot,

    /// Match statements give access to type-safe contextual information:
    /// - [path] is the wildcard segment of the path if there is one
    /// - [request] gives access to the [Request] object
    /// - [resource] gives access to the [Resource] object
    ///
    /// The [path] parameter name must match the name of the wildcard.
    /// The [request] and [resource] parameters must not  be renamed.
    matches: (database, request, resource) => [
      /// Subsequent matches should use typed [FirestoreResource] objects.
      /// This makes the [request] and [resource] parameters type-safe.
      Match<FirestoreResource<User>>(
        /// Paths are only allowed to contain one wildcard. If you need more
        /// wildcards, nest matches.
        '/users/{userId}',
      ),
    ],
  ),
];

@FirebaseRules(service: Service.storage)
final storageRules = [
  /// Always start with this match. [storageRoot] is the root of Storage.
  Match<StorageResource>(
    storageRoot,
    matches: (path, request, resource) => [
      /// All storage matches use [StorageResource] objects
      Match<StorageResource>(
        '/images/{imageId}',
      ),
    ],
  ),
];
