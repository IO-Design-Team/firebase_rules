import 'package:firebase_rules/firebase.dart';

/// All functions must return a bool
bool isSignedIn(RulesRequest request) {
  /// Null-safety operators will be stripped by the generator
  return request.auth?.uid != null;
}

@FirebaseRules(service: Service.firestore)
final rules = [
  Match<FirestoreRoot, FirestoreResource>(
    /// Functions are scoped to matches
    functions: [isSignedIn],
  )
];
