A type-safe Firebase rules generator for Firestore, Storage, and Realtime Database

## Features
- Create rules for Firestore, Storage, and Realtime Database in a type-safe environment
- Mimics the Firebase rules syntax for easy migration

The benefits:
- Type-safe access to your data model. Get errors if rules don't match the model.
- Rules are easier to read and maintain
- Split rules into multiple files for organization
- Add comments to Realtime Database rules

## Limitations
- All rules functions must be defined at the root level
- Realtime Database rules are not really type-safe, but you do get the benefit of having code completion

## Installation
```yaml
dependencies:
  firebase_rules: latest
  # If you are using types from `cloud_firestore_platform_interface`
  firebase_rules_convert: latest

dev_dependencies:
    build_runner: latest
    firebase_rules_generator: latest
```

## Usage

### Annotations

The starting point of all rules is the annotation. Firestore, Storage, and Database rules should be defined in their own files to prevent conflicts.

<!-- embedme readme/annotation.dart -->
```dart
import 'package:firebase_rules/database.dart';
import 'package:firebase_rules/firebase.dart';

/// Create rules for Firestore
@FirebaseRules(service: Service.firestore)
final firestoreRules = [];

/// Create rules for Storage
@FirebaseRules(service: Service.storage)
final storageRules = [];

/// Create rules for Realtime Database
@DatabaseRules()
final databaseRules = [];

```

### Paths

Path classes allow for type-safe access to path parameters

<!-- embedme readme/paths.dart -->
```dart
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

```

### Matches

Now we can start defining Match statements

<!-- embedme readme/match.dart -->
```dart
import 'package:firebase_rules/firebase.dart';
import 'paths.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  /// Always start with this match. [FirestoreRoot] is the root of Firestore.
  Match<FirestoreRoot, FirestoreResource>(
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
  /// Always start with this match. [StorageRoot] is the root of Storage.
  Match<StorageRoot, StorageResource>(
    matches: (path, request, resource) => [
      /// All storage matches use [StorageResource] objects
      Match<UsersPath, StorageResource>(),
    ],
  ),
];

```

### Rules

Rules are why we're here

<!-- embedme readme/rules.dart -->
```dart
import 'package:firebase_rules/firebase.dart';
import 'paths.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreRoot, FirestoreResource>(
    matches: (path, request, resource) => [
      Match<UsersPath, FirestoreResource<User>>(
        rules: (usersPath, request, resource) => [
          Allow([Operation.read], resource.data.userId == usersPath.userId)
        ],
      ),
    ],
  ),
];

```

### Rules Language

This package contains a reimplementation of the Firebase rules language in Dart. These calls are translated to the correct Firebase rules syntax by the generator.

<!-- embedme readme/language.dart -->
```dart
import 'package:firebase_rules/firebase.dart';

void example() {
  /// Dart objects can be converted to rules objects by calling `rules` on them
  ''.rules.range(0, 1);

  /// Methods called on `rules` types also take `rules` types as arguments
  [].rules.concat([].rules);

  /// Global rules functions are available on the `rules` object
  rules.string(true);

  /// Use the `raw` function if type-safe code is impractical
  rules.raw("foo.bar.baz == 'qux'");

  /// Types from `cloud_firestore_platform_interface` can also be converted
  /// with the `firebase_rules_convert` package
  /// ex: `Blob`, `GeoPoint`, `Timestamp`
}

```

### Functions

Top-level functions can be used as functions rules

<!-- embedme readme/functions.dart -->
```dart
import 'package:firebase_rules/firebase.dart';

/// All functions must return a bool
bool isSignedIn(RulesRequest request) {
  /// Null-safety operators will be stripped by the generator
  return request.auth?.uid != null;
}

@FirebaseRules(service: Service.firestore)
final rules = [
  Match<FirestoreRoot, FirestoreResource>(
    functions: [isSignedIn],
  )
];

```

### Organization

Any of the function arguments of a match statement can be split out for organization

<!-- embedme readme/organization.dart -->
```dart
import 'package:firebase_rules/firebase.dart';
import 'paths.dart';

/// Match parameter functions can be split out for organization. However, these
/// must be declared in the same file. Note that match functions cannot contain
/// a body.
List<Match> detached(
  FirestoreRoot root,
  RulesRequest<FirestoreResource> request,
  FirestoreResource resource,
) =>
    [
      Match<UsersPath, FirestoreResource<User>>(
        rules: (usersPath, request, resource) => [
          Allow([Operation.read], resource.data.userId == usersPath.userId)
        ],
      ),
    ];

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreRoot, FirestoreResource>(matches: detached),
];

```

### Generation

Finally, we can run the generator

```console
$ dart pub run build_runner build
```

For every `rules.dart` file, this will generate a `rules.rules` file in the same directory. Point your Firebase config to this file to use the rules.

## Realtime Database

Database rules are similar to Firestore and Storage rules, but they have a few differences:
- Database paths are raw strings
- The first match must start with `rules`. That is the root of the database.
- Wildcards are denoted with `$`
- If a path has a wildcard, it must be the last path segment. Database paths can only contain at most one wildcard.

<!-- embedme readme/database.dart -->
```dart
import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    r'rules/users/$userId',
    read: (userId) => auth != null && auth?.uid == userId,
    write: (userId) => userId == 'user1'.rules,
    validate: (userId) => !data.exists(),
    indexOn: ['uid', 'email'],
    matches: (userId) => [
      Match(
        r'contracts/$contractId',
        read: (contractId) =>
            root
                .child('users'.rules)
                .child(userId)
                .child(contractId)
                /// The `val` type parameters will be stripped by the generator
                .val<int?>() !=
            null,
        write: (contractId) =>
            root.child('users'.rules).child(userId).child(contractId).val() !=
            null,
      ),
    ],
  ),
];

```

## Additional Information

This package is still early in development. If you encounter any issues, please create an issue with a minimal reproducible sample.