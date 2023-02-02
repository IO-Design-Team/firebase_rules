import 'package:firebase_rules/firebase.dart';

bool isSignedIn() {
  /// Null-safety operators will be stripped by the generator
  /// 
  /// There is a globally available [request] object if type-safe access to
  /// [RulesRequest.resource] is not required.
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
