## 0.1.3+1
- Fix example typo

## 0.1.3
- Documentation updates for generator changes

## 0.1.2
- Adds extension on `Object` to allow converting any `Object` to a `RulesMap<String, dynamic>`
- The `RulesSet` methods `hasAll`, `hasAny`, `hasOnly` now accept either a `RulesSet` or `RulesList`

## 0.1.1
- Adds extension to `DateTime` to allow access to `RulesTimestamp` methods

## 0.1.0+1
- Documentation updates

## 0.1.0
- Renames `FirestorePath` to `FirestoreRoot` and `StoragePath` to `StorageRoot`
- `RuleDataSnapshot.val()` is now `RuleDataSnapshot.val<T>()` to allow for type-safety
- Adds a `customClaim<T>()` method to `RulesToken` to allow access to custom claims
- Functions are now declared on `Match` statements instead of the annotation
- `firestore.get<T>()` and `firestore.getAfter<T>()` now properly return a `FirestoreResource<T>`
- The conversion to rules types is now `.rules()` instead of `.rules` to allow for casting iterables and maps
- Enum conversion maps can now be passed into the `FirebaseRules` annotation
- Paths are now just a string parameter on a match. Wildcards are all strings anyways, and this is more flexible.
- Adds a globally accessible `request` object if type-safe access to the resource is not required
- `rules.raw()` is now `rules.raw<T>()` to allow for returning any type

## 0.0.1+2
- Readme fixes

## 0.0.1+1
- Readme fixes

## 0.0.1
- Initial release

## 0.0.0
- Early bird special
