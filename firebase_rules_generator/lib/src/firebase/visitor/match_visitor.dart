import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/visitor.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/function_visitor.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/rule_visitor.dart';
import 'package:firebase_rules_generator/src/common/util.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Match nodes
Stream<String> visitMatch(Context context, AstNode node) async* {
  final arguments = (node as MethodInvocation).argumentList.arguments;
  final pathArgument = arguments.first;
  final String path;
  if (pathArgument is SimpleStringLiteral) {
    path = pathArgument.value;
  } else if (pathArgument is SimpleIdentifier) {
    final pathElement =
        await context.get<TopLevelVariableElement>(pathArgument.name);
    final ast =
        await context.resolver.astNodeFor(pathElement) as VariableDeclaration;
    final pathString = ast.initializer as SimpleStringLiteral;
    path = pathString.value;
  } else {
    throw InvalidGenerationSourceError('Invalid match path ${node.toSource()}');
  }

  yield 'match $path {'.indent(context.indent);
  yield* _visitFunctions(context, arguments);
  yield* visitParameter(
    context,
    node,
    arguments,
    'rules',
    visitRule,
    validate: (expression) => _validateParameterFunction(path, expression),
  );
  yield* visitParameter(
    context,
    node,
    arguments,
    'matches',
    visitMatch,
    validate: (expression) => _validateParameterFunction(path, expression),
  );

  yield '}'.indent(context.indent);
}

/// Visit indexOn nodes
Stream<String> _visitFunctions(
  Context context,
  Iterable<SyntacticEntity> node,
) async* {
  final parameter = getNamedParameter('functions', node);
  if (parameter == null) return;
  parameter as ListLiteral;
  for (final element in parameter.elements) {
    element as SimpleIdentifier;
    final functionElement = await context.get(element.name);
    final function = await context.resolver.astNodeFor(functionElement);
    yield* visitFunction(context.dive(), function as FunctionDeclaration);
  }
}

void _validateParameterFunction(String path, FunctionExpression function) {
  final String expectedWildcardParameterName;
  final pathWildcards = RegExp(r'\{(\w+)\}').allMatches(path);
  if (pathWildcards.length > 1) {
    throw InvalidGenerationSourceError(
      'Path cannot contain more than one wildcard: $path',
    );
  } else if (pathWildcards.length == 1) {
    expectedWildcardParameterName = pathWildcards.single[1]!;
  } else {
    expectedWildcardParameterName = '_';
  }

  final expectedSignature =
      '($expectedWildcardParameterName, request, resource)';
  final actualSignature = function.parameters.toString();
  if (expectedSignature != actualSignature) {
    throw InvalidGenerationSourceError(
      'Invalid signature: $actualSignature\nExpected: $expectedSignature',
    );
  }
}
