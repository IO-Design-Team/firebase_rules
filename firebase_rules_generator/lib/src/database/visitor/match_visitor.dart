import 'package:analyzer/dart/ast/ast.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/visitor.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/rule_visitor.dart';
import 'package:firebase_rules_generator/src/common/util.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Match nodes
Stream<String> visitMatch(Context context, AstNode node) async* {
  final arguments = (node as MethodInvocation).argumentList.arguments;
  final path = (arguments.first as SimpleStringLiteral).value;
  final segments = path.split('/');

  for (final segment in segments) {
    yield '"$segment": {'.indent(context.indent);
    context = context.dive();
  }

  // Must have at least two arguments
  if (arguments.length < 2) {
    throw InvalidGenerationSourceError(
      'Match missing arguments: ${node.toSource()}',
    );
  }

  yield* visitParameter(context, node, arguments, 'rules', visitRule);
  yield* visitParameter(context, node, arguments, 'matches', visitMatch);

  for (var i = 1; i <= segments.length; i++) {
    yield '}'.indent(context.indent - i * 2);
  }
}
