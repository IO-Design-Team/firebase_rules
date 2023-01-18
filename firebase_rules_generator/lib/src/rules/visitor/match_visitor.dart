import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:collection/collection.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:firebase_rules_generator/src/rules/visitor/rule_visitor.dart';
import 'package:firebase_rules_generator/src/util.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Match nodes
Stream<String> visitMatch(RulesContext context, AstNode node) async* {
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

  yield* _visitParameter(context, node, arguments, 'rules', visitRule);
  yield* _visitParameter(context, node, arguments, 'matches', visitMatch);

  yield '}'.indent(context.indent);
}

Future<String> _getPath(RulesContext context, AstNode node) async {
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

String _getParameterName(FunctionExpression function, int index) {
  final parameter = function.parameters!.childEntities.elementAt(index + 1)
      as SimpleFormalParameter;
  return parameter.name!.toString();
}

Stream<String> _visitParameter(
  RulesContext context,
  AstNode node,
  Iterable<SyntacticEntity> arguments,
  String name,
  Stream<String> Function(RulesContext context, CollectionElement element)
      visit,
) async* {
  final expression = arguments
      .whereType<NamedExpression>()
      .where((e) => e.name.label.name == name)
      .firstOrNull
      ?.expression;
  if (expression == null) return;

  final FunctionExpression function;
  final bool cleanContext;
  if (expression is FunctionExpression) {
    function = expression;
    cleanContext = false;
  } else if (expression is SimpleIdentifier) {
    // If this is a reference to a function, find the function declaration
    final element = context.library.allElements
        .singleWhere((e) => e.name == expression.name);
    final ast =
        await context.resolver.astNodeFor(element) as FunctionDeclaration;
    function = ast.functionExpression;
    cleanContext = true;
  } else {
    throw InvalidGenerationSourceError(
      'Invalid match function: ${expression.toSource()}',
    );
  }

  // Validate the request and resource parameters
  final requestParameter = _getParameterName(function, 1);
  if (requestParameter != 'request') {
    throw InvalidGenerationSourceError(
      'Request parameter misnamed: $requestParameter}',
    );
  }

  final resourceParameter = _getParameterName(function, 2);
  if (resourceParameter != 'resource') {
    throw InvalidGenerationSourceError(
      'Resource parameter misnamed: $resourceParameter}',
    );
  }

  final pathParameter = _getParameterName(function, 0);

  final elements = function.body.childEntities
      .whereType<ListLiteral>()
      .firstOrNull
      ?.elements;
  if (elements == null) {
    throw InvalidGenerationSourceError(
      'Match parameter must be a list literal: ${node.toSource()}',
    );
  }

  for (final element in elements) {
    yield* visit(
      context.dive(clean: cleanContext, paths: {pathParameter}),
      element,
    );
  }
}
