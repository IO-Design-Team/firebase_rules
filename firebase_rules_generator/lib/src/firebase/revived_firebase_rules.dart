import 'package:analyzer/dart/element/element.dart';
import 'package:firebase_rules/firebase.dart';

/// Revived FirebaseRules annotation
class RevivedFirebaseRules {
  /// rulesVersion
  final String rulesVersion;

  /// service
  final Service service;

  /// functions
  final Iterable<ExecutableElement> functions;

  /// enums
  final Iterable<Map<String, String>> enums;

  /// Constructor
  const RevivedFirebaseRules({
    required this.rulesVersion,
    required this.service,
    required this.functions,
    required this.enums,
  });
}
