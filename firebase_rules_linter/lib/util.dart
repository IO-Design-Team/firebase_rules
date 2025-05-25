import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
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
Future<DartObject?> getFirebaseRulesAnnotation(
  CustomLintResolver resolver,
) async {
  final resolved = await resolver.getResolvedUnitResult();

  /// TODO: Fix with analyzer 8
  /// ignore: deprecated_member_use
  for (final element in resolved.libraryElement.topLevelElements) {
    final annotation = firebaseRulesTypeChecker.firstAnnotationOfExact(element);
    if (annotation != null) return annotation;
  }
  return null;
}
