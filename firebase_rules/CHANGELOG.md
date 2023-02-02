## NEXT
- Renames `FirestorePath` to `FirestoreRoot` and `StoragePath` to `StorageRoot`
- `RuleDataSnapshot.val()` is now `RuleDataSnapshot.val<T>()` to allow for type-safety
- Adds a `customClaim<T>()` method to `RulesToken` to allow access to custom claims
- Functions are now declared on `Match` statements instead of the annotation
- `firestore.get<T>()` and `firestore.getAfter<T>()` now properly return a `FirestoreResource<T>`
- The conversion to rules types is now `.rules()` instead of `.rules` to allow for casting iterables and maps
- Enum conversion maps can now be passed into the `FirebaseRules` annotation

## 0.0.1+2
- Readme fixes

## 0.0.1+1
- Readme fixes

## 0.0.1
- Initial release

## 0.0.0
- Early bird special
