import 'package:firebase_rules/firebase.dart';
import 'shared.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  /// Always start with this match. [firestoreRoot] is the root of Firestore.
  Match<FirestoreResource>(
    firestoreRoot,

    /// Match statements give access to type-safe contextual information:
    /// - The first parameter is the wildcard. Use `_` if there is no wildcard.
    /// - [request] gives access to the [Request] object
    /// - [resource] gives access to the [Resource] object
    ///
    /// The wildcard parameter must match the the path wildcard
    /// The wildcard for [firestoreRoot] is `database`
    /// The [request] and [resource] parameters must not be renamed
    matches: (database, request, resource) => [
      /// Subsequent matches should use typed [FirestoreResource] objects.
      /// This makes the [request] and [resource] parameters type-safe.
      Match<FirestoreResource<User>>(
        /// Paths are only allowed to contain one wildcard. If you need more
        /// wildcards, nest matches.
        '/users/{userId}',
        /// The [userId] parameter matches the `userId` wildcard
        rules: (userId, reqquest, resource) => [],
      ),
      Match<FirestoreResource>(
        '/other/stuff',
        /// Since there is no wildcard in this path, use `_`
        rules: (_, request, resource) => [],
      ),
    ],
  ),
];

@FirebaseRules(service: Service.storage)
final storageRules = [
  /// Always start with this match. [storageRoot] is the root of Storage.
  Match<StorageResource>(
    storageRoot,
    /// The wildcard for [storageRoot] is `bucket`
    matches: (bucket, request, resource) => [
      /// All storage matches use [StorageResource] objects
      Match<StorageResource>(
        '/images/{imageId}',
      ),
    ],
  ),
];
