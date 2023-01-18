import 'package:analyzer/dart/ast/ast.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Match elements
String visitMatch(LibraryReader library, AstNode node) {
  final typeArguments = node.childEntities.whereType<TypeArgumentList>().single;
  final pathType = typeArguments.arguments[0];
  final pathClassName = pathType.toSource();
  final pathClass = library.findType(pathClassName);

  final String path;
  if (pathClass == null) {
    if (pathClassName == 'FirestorePath') {
      path = FirestorePath.rawPath;
    } else if (pathClassName == 'StoragePath') {
      path = StoragePath.rawPath;
    } else {
      throw InvalidGenerationSourceError(
        'Invalid path type: $pathClassName',
        element: pathClass,
      );
    }
  } else {
    path = pathClass.getField('path')!.computeConstantValue()!.toStringValue()!;
  }

  print(path);

  return '';
}
