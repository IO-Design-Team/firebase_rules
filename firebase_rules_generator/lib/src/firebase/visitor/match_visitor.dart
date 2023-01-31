import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/visitor.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/rule_visitor.dart';
import 'package:firebase_rules_generator/src/common/util.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Match nodes
Stream<String> visitMatch(Context context, AstNode node) async* {
  final path = await _getPath(context, node);

  yield 'match $path {'.indent(context.indent);

  final arguments =
      node.childEntities.whereType<ArgumentList>().single.childEntities;
  // Argument lists have beginning and end tokens
  if (arguments.length - 2 == 0) {
    throw InvalidGenerationSourceError(
      'Match missing arguments: ${node.toSource()}',
    );
  }

  yield* visitParameter(
    context,
    node,
    arguments,
    'rules',
    visitRule,
    validate: _validateParameterFunction,
  );
  yield* visitParameter(
    context,
    node,
    arguments,
    'matches',
    visitMatch,
    validate: _validateParameterFunction,
  );

  yield '}'.indent(context.indent);
}

void _validateParameterFunction(FunctionExpression function) {
  final requestParameter = getParameterName(function, 1);
  if (requestParameter != 'request') {
    throw InvalidGenerationSourceError(
      'Request parameter misnamed: $requestParameter}',
    );
  }

  final resourceParameter = getParameterName(function, 2);
  if (resourceParameter != 'resource') {
    throw InvalidGenerationSourceError(
      'Resource parameter misnamed: $resourceParameter}',
    );
  }
}

Future<String> _getPath(Context context, AstNode node) async {
  final typeArguments =
      node.childEntities.whereType<TypeArgumentList>().firstOrNull;
  if (typeArguments == null) {
    throw InvalidGenerationSourceError(
      'Match missing type annotations: ${node.toSource()}',
    );
  }

  final pathName = typeArguments.arguments[0].toSource();
  final pathElement = context.library.findType(pathName);

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
    final ast = await context.resolver.astNodeFor(pathElement);
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

  return path;
}
