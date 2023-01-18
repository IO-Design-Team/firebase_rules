import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:collection/collection.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:firebase_rules_generator/src/rules/visitor/rule_visitor.dart';
import 'package:firebase_rules_generator/src/util.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Match elements
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

Stream<String> _visitRules(
  RulesContext context,
  AstNode node,
  Iterable<SyntacticEntity> arguments,
) async* {
  final rulesFunction = arguments
      .whereType<NamedExpression>()
      .where((e) => e.name.label.name == 'rules')
      .firstOrNull
      ?.expression as FunctionExpression?;
  if (rulesFunction == null) return;

  final rulesFunctionChildren = rulesFunction.body.childEntities;
  if (rulesFunctionChildren.whereType<Block>().isNotEmpty) {
    throw InvalidGenerationSourceError(
      'Match rules must be a list literal: ${node.toSource()}',
    );
  }

  final rules = rulesFunctionChildren.whereType<ListLiteral>().single.elements;
  for (final rule in rules) {
    yield* visitRule(context.dive(), rule);
  }
}

Stream<String> _visitMatches(
  RulesContext context,
  AstNode node,
  Iterable<SyntacticEntity> arguments,
) async* {
  final matchesFunction = arguments
      .whereType<NamedExpression>()
      .where((e) => e.name.label.name == 'matches')
      .firstOrNull
      ?.expression as FunctionExpression?;
  if (matchesFunction == null) return;

  final matchesFunctionChildren = matchesFunction.body.childEntities;
  final block = matchesFunctionChildren.whereType<Block>().firstOrNull;

  final NodeList<CollectionElement> matches;
  if (block != null) {
    // TODO: Deal with this
    return;
  } else {
    matches = matchesFunctionChildren.whereType<ListLiteral>().single.elements;
  }

  for (final match in matches) {
    yield* visitMatch(context.dive(), match);
  }
}
