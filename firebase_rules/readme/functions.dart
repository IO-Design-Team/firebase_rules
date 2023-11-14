import 'package:firebase_rules/firebase.dart';

bool isSignedIn() {
  /// Null-safety operators will be stripped by the generator
  ///
  /// There is a globally available [request] object if type-safe access to
  /// [RulesRequest.resource] is not required. Otherwise, pass a typed
  /// [RulesRequest] object to the function.
  return request.auth?.uid != null;
}

@FirebaseRules(
  service: Service.firestore,

  /// Functions must be declared at a top level
  functions: [isSignedIn],
)
final rules = [
  Match<FirestoreResource>(
    firestoreRoot,
  ),
];
