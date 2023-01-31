import 'package:firebase_rules/firebase.dart';

/// All functions must return a bool
bool isSignedIn(RulesRequest request) {
  /// Null-safety operators will be stripped by the generator
  return request.auth?.uid != null;
}

@FirebaseRules(
  service: Service.firestore,

  /// Functions must be declared here in order to be generated. This allows for
  /// one project to contain multiple rulesets.
  functions: [isSignedIn],
)
final rules = [];
