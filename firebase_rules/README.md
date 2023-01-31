A type-safe Firebase rules generator for Firestore, Storage, and Realtime Database

## Features
- Create rules for Firestore, Storage, and Realtime Database in a type-safe environment
- Mimics the Firebase rules syntax for easy migration

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

