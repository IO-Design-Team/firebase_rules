import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:collection/collection.dart';
import 'package:firebase_rules_generator/src/common/rules_context.dart';
import 'package:source_gen/source_gen.dart';

/// Get the parameter name of the given index
String getParameterName(FunctionExpression function, int index) {
  final parameter = function.parameters!.childEntities.elementAt(index + 1)
      as SimpleFormalParameter;
  return parameter.name!.toString();
}

/// Get a parameter by name
AstNode? getNamedParameter(String name, Iterable<SyntacticEntity> arguments) {
  return arguments
      .whereType<NamedExpression>()
      .firstWhereOrNull((e) => e.name.label.name == name)
      ?.expression;
}

/// Visit a function parameter
Stream<String> visitParameter(
  RulesContext context,
  AstNode node,
  Iterable<SyntacticEntity> arguments,
  String name,
  Stream<String> Function(RulesContext context, AstNode element) visit, {
  void Function(FunctionExpression function)? validate,
}) async* {
  final expression = getNamedParameter(name, arguments);
  if (expression == null) return;

  final FunctionExpression function;
  final bool cleanContext;
  if (expression is FunctionExpression) {
    function = expression;
    cleanContext = false;
  } else if (expression is SimpleIdentifier) {
    // If this is a reference to a function, find the function declaration
    final element = await context.get(expression.name);
    final ast =
        await context.resolver.astNodeFor(element) as FunctionDeclaration;
    function = ast.functionExpression;
    cleanContext = true;
  } else {
    throw InvalidGenerationSourceError(
      'Invalid match function: ${expression.toSource()}',
    );
  }

  validate?.call(function);

  final wildcard = getParameterName(function, 0);
  final elements = function.body.childEntities
      .whereType<ListLiteral>()
      .firstOrNull
      ?.elements;

  final newContext = context.dive(clean: cleanContext, wildcards: {wildcard});
  if (elements == null) {
    yield* visit(newContext, function.body);
  } else {
    for (final element in elements) {
      yield* visit(newContext, element);
    }
  }
}
