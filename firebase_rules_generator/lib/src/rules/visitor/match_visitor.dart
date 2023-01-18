import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:collection/collection.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:firebase_rules_generator/src/rules/visitor/function_visitor.dart';
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

  yield* _visitRules(context, node, arguments);
  yield* _visitMatches(context, node, arguments);

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

Future<FunctionExpression?> _getFunction(
  RulesContext context,
  Iterable<SyntacticEntity> arguments,
  String name,
) async {
  final expression = arguments
      .whereType<NamedExpression>()
      .where((e) => e.name.label.name == name)
      .firstOrNull
      ?.expression;
  if (expression == null) return null;

  final FunctionExpression function;
  if (expression is FunctionExpression) {
    function = expression;
  } else if (expression is SimpleIdentifier) {
    final element = context.library.allElements
        .singleWhere((e) => e.name == expression.name);
    final ast =
        await context.resolver.astNodeFor(element) as FunctionDeclaration;
    function = ast.functionExpression;
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

  return function;
}

Stream<String> _visitRules(
  RulesContext context,
  AstNode node,
  Iterable<SyntacticEntity> arguments,
) async* {
  final rulesFunction = await _getFunction(context, arguments, 'rules');
  if (rulesFunction == null) return;

  final pathParameter = _getParameterName(rulesFunction, 0);

  final rulesFunctionChildren = rulesFunction.body.childEntities;
  if (rulesFunctionChildren.whereType<Block>().isNotEmpty) {
    throw InvalidGenerationSourceError(
      'Match rules must be a list literal: ${node.toSource()}',
    );
  }

  final rules = rulesFunctionChildren.whereType<ListLiteral>().single.elements;
  for (final rule in rules) {
    yield* visitRule(context.dive(paths: {pathParameter}), rule);
  }
}

Stream<String> _visitMatches(
  RulesContext context,
  AstNode node,
  Iterable<SyntacticEntity> arguments,
) async* {
  final matchesFunction = await _getFunction(context, arguments, 'matches');
  if (matchesFunction == null) return;

  final pathParameter = _getParameterName(matchesFunction, 0);

  final matchesFunctionChildren = matchesFunction.body.childEntities;
  final block = matchesFunctionChildren.whereType<Block>().firstOrNull;

  final Iterable<FunctionDeclaration> functions;
  final NodeList<CollectionElement> matches;
  if (block != null) {
    final statements = block.statements;
    functions = statements
        .whereType<FunctionDeclarationStatement>()
        .map((e) => e.functionDeclaration);
    matches = statements
        .whereType<ReturnStatement>()
        .single
        .childEntities
        .whereType<ListLiteral>()
        .single
        .elements;
  } else {
    functions = [];
    matches = matchesFunctionChildren.whereType<ListLiteral>().single.elements;
  }

  for (final function in functions) {
    yield* visitFunction(context.dive(), function);
  }

  for (final match in matches) {
    yield* visitMatch(
      context.dive(
        paths: {pathParameter},
        functions: functions.map((e) => e.name.toString()).toSet(),
      ),
      match,
    );
  }
}
