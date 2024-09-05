## 0.2.2

- Uses the `default` Firestore database if none is specified in Storage rules

## 0.2.1

- Support for `firebase_rules: ^0.2.0`

## 0.2.0

- BREAKING: Proper function signatures are now enforced

## 0.1.1

- Dependency upgrades

## 0.1.0

- Updates to support `firebase_rules` changes
- Translate `r"..."` to `"..."` instead of `'...'`
- Strip null check (`!`) operators
- Ignore paths that equal `_`
- Database string `matches(regex)` regex now must include the leading and trailing `/`
- Fixes issue with raw matching
- Raws are now completely ignored during sanitization
- Improvements to string interpolation handling
- `rules.path('/path/to/resource')` now translates to `/path/to/resource`
- Fixed handling of `!type.contains()`

## 0.0.1

- Initial release

## 0.0.0

- Early bird special
