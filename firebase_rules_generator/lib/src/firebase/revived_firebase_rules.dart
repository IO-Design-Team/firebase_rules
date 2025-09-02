import 'package:analyzer/dart/element/element2.dart';
import 'package:firebase_rules/firebase.dart';
import 'package:meta/meta.dart';

/// Revived FirebaseRules annotation
@immutable
class RevivedFirebaseRules {
  /// rulesVersion
  final String rulesVersion;

  /// service
  final Service service;

  /// functions
  final Iterable<ExecutableElement2> functions;

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
