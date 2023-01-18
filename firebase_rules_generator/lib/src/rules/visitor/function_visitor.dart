import 'package:analyzer/dart/ast/ast.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:firebase_rules_generator/src/util.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Function nodes
Stream<String> visitFunction(
  RulesContext context,
  FunctionDeclaration node,
) async* {
  final name = node.name.toString();
  final parameters = node.functionExpression.parameters?.parameters
      .map((e) => e.name)
      .join(', ');
  yield 'function $name($parameters) {'.indent(context.indent);
  yield* _visitFunctionBody(context.dive(), node.functionExpression.body);
  yield '}'.indent(context.indent);
}

Stream<String> _visitFunctionBody(
  RulesContext context,
  FunctionBody body,
) async* {
  if (body is BlockFunctionBody) {
    final statements = body.block.statements;
    for (final statement in statements) {
      if (statement is VariableDeclarationStatement) {
        final variable = statement.variables.variables.single;
        final name = variable.name;
        final initializer =
            variable.initializer!.toSource().replaceAll('?', '');
        yield 'let $name = $initializer;'.indent(context.indent);
      } else if (statement is ReturnStatement) {
        final expression = statement.expression;
        yield 'return $expression;'.indent(context.indent);
      } else {
        throw InvalidGenerationSourceError(
          'Unsupported function statement type: $statement',
        );
      }
    }
  } else if (body is ExpressionFunctionBody) {
    final expression = body.expression;
    yield '$expression;'.indent(context.indent);
  } else {
    throw InvalidGenerationSourceError('Unsupported function body type: $body');
  }
}
