import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Type checker for any `firebase_rules` type
const libraryTypeChecker = TypeChecker.fromPackage('firebase_rules');

/// Type checker for `FirebaseRules`
const firebaseRulesTypeChecker =
    TypeChecker.fromName('FirebaseRules', packageName: 'firebase_rules');

/// Type checker for `FirebaseMatch`
const firebaseMatchChecker =
    TypeChecker.fromName('FirebaseMatch', packageName: 'firebase_rules');

/// Type checker for `DatabaseMatch`
const databaseMatchChecker =
    TypeChecker.fromName('DatabaseMatch', packageName: 'firebase_rules');

/// Resolve a match path
String? resolveMatchPath({required NodeList<Expression> arguments}) {
  final pathArgument = arguments.first;
  if (pathArgument is SimpleStringLiteral) {
    return pathArgument.value;
  } else if (pathArgument is SimpleIdentifier) {
    final pathName = pathArgument.name;
    if (pathName == 'firestoreRoot') {
      return '/databases/{database}/documents';
    } else if (pathName == 'storageRoot') {
      return '/b/{bucket}/o';
    }
  }

  // The path is invalid
  return null;
}

/// Get the first `FirebaseRules` annotation in a file
DartObject? getFirebaseRulesAnnotation(ResolvedUnitResult resolved) {
  for (final element in resolved.libraryElement.topLevelElements) {
    final annotation = firebaseRulesTypeChecker.firstAnnotationOfExact(element);
    if (annotation != null) return annotation;
  }
  return null;
}

// TODO: Remove when Flutter supports meta version 1.14.0
/// Wrapper to contain necessary deprected calls
extension DeprecatedErrorReporterExtension on ErrorReporter {
  /// deprecatedReportErrorForNode
  void deprecatedReportErrorForNode(
    ErrorCode errorCode,
    AstNode node, [
    List<Object>? arguments,
    List<DiagnosticMessage>? contextMessages,
    Object? data,
  ]) =>
      // ignore: deprecated_member_use
      reportErrorForNode(errorCode, node, arguments, contextMessages, data);

  /// deprecatedReportErrorForToken
  void deprecatedReportErrorForToken(
    ErrorCode errorCode,
    Token token, [
    List<Object>? arguments,
    List<DiagnosticMessage>? contextMessages,
    Object? data,
  ]) =>
      // ignore: deprecated_member_use
      reportErrorForToken(errorCode, token, arguments, contextMessages, data);
}
