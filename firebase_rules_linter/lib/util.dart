import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Type checker for `FirebaseMatch`
const firebaseMatchChecker =
    TypeChecker.fromName('FirebaseMatch', packageName: 'firebase_rules');

/// Type checker for `DatabaseMatch`
const databaseMatchChecker =
    TypeChecker.fromName('DatabaseMatch', packageName: 'firebase_rules');

/// Get a parameter by name
AstNode? getNamedParameter({
  required Iterable<SyntacticEntity> arguments,
  required String name,
}) {
  return arguments
      .whereType<NamedExpression>()
      .firstWhereOrNull((e) => e.name.label.name == name)
      ?.expression;
}

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
