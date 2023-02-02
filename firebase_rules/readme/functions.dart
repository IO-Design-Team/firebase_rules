import 'package:firebase_rules/firebase.dart';

bool isSignedIn(RulesRequest request) {
  /// Null-safety operators will be stripped by the generator
  return request.auth?.uid != null;
}

@FirebaseRules(service: Service.firestore)
final rules = [
  Match<FirestoreResource>(
    firestoreRoot,

    /// Functions are scoped to matches, but must be declared as top-level
    /// functions
    functions: [isSignedIn],
  )
];
