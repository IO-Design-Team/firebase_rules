import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:firebase_rules_generator/src/rules/visitor/rule_visitor.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Match elements
Stream<String> visitMatch(
  LibraryReader library,
  Resolver resolver,
  AstNode node, {
  int indent = 2,
}) async* {
  final typeArguments =
      node.childEntities.whereType<TypeArgumentList>().firstOrNull;
  if (typeArguments == null) {
    throw InvalidGenerationSourceError(
      'Match missing type annotations: ${node.toSource()}',
    );
  }

  final pathName = typeArguments.arguments[0].toSource();
  final pathElement = library.findType(pathName);

  final String path;
  if (pathElement == null) {
    if (pathName == 'FirestorePath') {
      path = FirestorePath.rawPath;
    } else if (pathName == 'StoragePath') {
      path = StoragePath.rawPath;
    } else {
      throw InvalidGenerationSourceError(
        'Invalid path type: $pathName',
        element: pathElement,
      );
    }
  } else {
    final ast = await resolver.astNodeFor(pathElement);
    final pathMethod = ast!.childEntities
        .whereType<MethodDeclaration>()
        .where((e) => e.name.toString() == 'path');
    final pathString = pathMethod.single.body.childEntities
        .whereType<StringLiteral>()
        .single
        .toSource();
    path = pathString
        .substring(1, pathString.length - 1)
        .replaceAllMapped(RegExp(r'\$([^\/]+)'), (m) => '{${m[1]}}');
  }

  yield 'match $path {';

  final arguments =
      node.childEntities.whereType<ArgumentList>().single.childEntities;
  // Argument lists have beginning and end tokens
  if (arguments.length - 2 == 0) {
    throw InvalidGenerationSourceError(
      'Match missing arguments: ${node.toSource()}',
    );
  }

  final rulesFunction = arguments
      .whereType<NamedExpression>()
      .where((e) => e.name.label.name == 'rules')
      .single
      .expression as FunctionExpression;
  final rules =
      rulesFunction.body.childEntities.whereType<ListLiteral>().single.elements;
  if (rules.isEmpty) {
    throw InvalidGenerationSourceError(
      'Match defines empty rules: ${node.toSource()}',
    );
  }

  for (final rule in rules) {
    yield* visitRule(rule);
  }

  yield '}';
}
