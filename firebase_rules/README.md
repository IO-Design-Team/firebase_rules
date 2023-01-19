A type-safe Firebase rules generator for Firestore, Storage, and Realtime Database

## Super Early Bird Special
- Is this package production ready: no
- What works: the example
- What doesn't work: probably everything else
- Where is the documentation: nowhere

If you want to try it anyways, great! Please let me know what's broken.

How to add it to your project:
```yaml
dependencies:
  firebase_rules: ^0.0.0
  # Temporary helper package
  firebase_rules_convert:
    git: 
      url: https://github.com/IO-Design-Team/firebase_rules
      path: firebase_rules_convert

dev_dependencies:
    build_runner: ^2.3.3
    firebase_rules_generator: ^0.0.0
```