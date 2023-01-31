import 'package:analyzer/dart/element/element.dart';
import 'package:firebase_rules/firebase.dart';

/// Revived [FirebaseRules] annotation
class RevivedFirebaseRules {
  /// The rules version. Defaults to 2.
  final String rulesVersion;

  /// The firebase service these rules are for
  final Service service;

  /// Functions to include in these rules
  final List<FunctionElement> functions;

  /// Constructor
  const RevivedFirebaseRules({
    required this.rulesVersion,
    required this.service,
    required this.functions,
  });
}
