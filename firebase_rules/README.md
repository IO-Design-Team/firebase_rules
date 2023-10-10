A type-safe Firebase rules generator for Firestore, Storage, and Realtime Database

## Features
- Create rules for Firestore, Storage, and Realtime Database in a type-safe environment
- Mimics the Firebase rules syntax for easy migration

The benefits:
- Type-safe access to your data model. Get errors if rules don't match the model.
- Code completion for the rules language. No more guessing what functions are available.
- Rules are easier to read and maintain
- Add comments to Realtime Database rules

## Limitations
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

### Matches

Now we can start defining Match statements

<!-- embedme readme/match.dart -->
```dart
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

```

### Rules

Rules are why we're here

<!-- embedme readme/rules.dart -->
```dart
import 'package:firebase_rules/firebase.dart';
import 'shared.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    matches: (database, request, resource) => [
      Match<FirestoreResource<User>>(
        '/users/{userId}',
        rules: (userId, request, resource) => [
          Allow([Operation.read], resource.data.userId.rules() == userId),
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
  /// Dart objects can be converted to rules objects by calling `.rules()` on them
  ''.rules().range(0, 1);

  /// Methods called on `rules` types also take `rules` types as arguments.
  /// Calling `.rules()` on an iterable or map also allows for casting.
  [].rules<RulesString>().concat([].rules());

  /// Global rules functions are available on the `rules` object
  rules.string(true);

  /// Use the `raw` function if type-safe code is impractical.
  /// The `raw` function also allows for casting.
  rules.raw<bool>("foo.bar.baz == 'qux'");

  /// Types from `cloud_firestore_platform_interface` can also be converted
  /// with the `firebase_rules_convert` package
  /// ex: `Blob`, `GeoPoint`, `Timestamp`
}

```

### Functions

Top-level functions can be used as rules functions

<!-- embedme readme/functions.dart -->
```dart
import 'package:firebase_rules/firebase.dart';

bool isSignedIn() {
  /// Null-safety operators will be stripped by the generator
  ///
  /// There is a globally available [request] object if type-safe access to
  /// [RulesRequest.resource] is not required. Otherwise, pass a typed
  /// [RulesRequest] object to the function.
  return request.auth?.uid != null;
}

@FirebaseRules(service: Service.firestore)
final rules = [
  Match<FirestoreResource>(
    firestoreRoot,

    /// Functions are scoped to matches, but must be declared as top-level
    /// functions
    functions: [isSignedIn],
  ),
];

```

### Organization

Any of the function arguments of a match statement can be split out for organization

<!-- embedme readme/organization.dart -->
```dart
import 'package:firebase_rules/firebase.dart';
import 'shared.dart';

/// Match parameter functions can be split out for organization. However, these
/// must be declared in the same file. Note that match functions cannot contain
/// a body.
List<Match> detached(
  RulesString database,
  RulesRequest<FirestoreResource> request,
  FirestoreResource resource,
) =>
    [
      Match<FirestoreResource<User>>(
        '/users/{userId}',
        rules: (userId, request, resource) => [
          Allow([Operation.read], resource.data.userId.rules() == userId),
        ],
      ),
    ];

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot, matches: detached),
];

```

### Enums

Enums can be replaced with raw strings by the generator

<!-- embedme readme/enums.dart -->
```dart
import 'package:firebase_rules/firebase.dart';

@FirebaseRules(
  service: Service.firestore,

  /// Pass in enum conversion maps for all enums you plan to use in these rules
  enums: [Test.map],
)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    matches: (database, request, resource) => [
      Match<FirestoreResource<TestResource>>(
        '/test',
        rules: (_, request, resource) => [
          Allow([Operation.read], resource.data.test == Test.a),
        ],
      ),
    ],
  ),
];

enum Test {
  a,
  b,
  c;

  static const map = {
    Test.a: 'a',
    Test.b: 'b',
    Test.c: 'c',
  };
}

abstract class TestResource {
  Test get test;
}

```

### Generation

Finally, we can run the generator

```console
$ dart pub run build_runner build
```

For every `rules.dart` file, this will generate a `rules.rules` file in the same directory. Point your Firebase config to this file to use the rules.

## Realtime Database

Database rules are similar to Firestore and Storage rules, but they have a few differences:
- The first match must start with `rules`. That is the root of the database.
- Wildcards are denoted with `$`

<!-- embedme readme/database.dart -->
```dart
import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    /// First match must start with `rules`
    r'rules/users/$userId',

    /// The path parameter must match the wildcard name
    read: (userId) => auth != null && auth?.uid == userId,
    write: (userId) => userId == 'user1'.rules(),
    validate: (userId) => !data.exists(),
    indexOn: ['uid', 'email'],
    matches: (userId) => [
      Match(
        r'contracts/$contractId',
        read: (contractId) =>
            root
                .child('users'.rules())
                .child(userId)
                .child(contractId)

                /// The `val` type parameters will be stripped by the generator
                .val<int?>() !=
            null,
        write: (contractId) =>
            root.child('users'.rules()).child(userId).child(contractId).val() !=
            null,
      ),
    ],
  ),
];

```

## Additional Information

This package is still early in development. If you encounter any issues, please create an issue with a minimal reproducible sample.
