import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/validator.dart';
import 'package:firebase_rules_generator/src/common/visitor.dart';
import 'package:firebase_rules_generator/src/database/sanitizer.dart';
import 'package:firebase_rules_generator/src/common/util.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Match nodes
Stream<String> visitMatch(Context context, AstNode node) async* {
  final arguments = (node as MethodInvocation).argumentList.arguments;
  final path = (arguments.first as SimpleStringLiteral).value;
  final segments = path.split('/');

  for (var i = 0; i < segments.length; i++) {
    final segment = segments[i];
    yield '"$segment": {'.indent(context.indent);
    if (i != segments.length - 1) {
      // Don't dive on the last segment
      context = context.dive();
    }
  }

  // Must have at least two arguments
  if (arguments.length < 2) {
    throw InvalidGenerationSourceError(
      'Match missing arguments: ${node.toSource()}',
    );
  }

  void validate(FunctionExpression expression) => validateFunctionParameters(
        path: path,
        wildcardMatcher: r'\$(\w+)',
        function: expression,
        createExpectedSignature: (wildcard) => '($wildcard)',
      );

  yield* visitParameter(
    context,
    node,
    arguments,
    'read',
    (context, node) => _visitRule('read', context, node),
    validate: validate,
  );
  yield* visitParameter(
    context,
    node,
    arguments,
    'write',
    (context, node) => _visitRule('write', context, node),
    validate: validate,
  );
  yield* visitParameter(
    context,
    node,
    arguments,
    'validate',
    (context, node) => _visitRule('validate', context, node),
    validate: validate,
  );
  yield* _visitIndexOn(context.dive(), arguments);
  yield* visitParameter(
    context,
    node,
    arguments,
    'matches',
    visitMatch,
    validate: validate,
  );

  for (var i = 0; i < segments.length; i++) {
    yield '},'.indent(context.indent - i * 2);
  }
}

/// Visit indexOn nodes
Stream<String> _visitIndexOn(
  Context context,
  List<SyntacticEntity> node,
) async* {
  final source = getNamedParameter('indexOn', node)?.toSource();
  if (source == null) return;
  final list = source.replaceAll("'", '"');
  yield '".indexOn": $list,'.indent(context.indent);
}

/// Visit Rule nodes
Stream<String> _visitRule(
  String operation,
  Context context,
  AstNode node,
) async* {
  final expression = (node as ExpressionFunctionBody).expression;
  final condition = sanitizePaths(context, expression.toSource());
  yield '".$operation": "$condition",'.indent(context.indent);
}
