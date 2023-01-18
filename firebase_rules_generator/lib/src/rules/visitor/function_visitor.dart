import 'package:analyzer/dart/ast/ast.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:firebase_rules_generator/src/util.dart';

/// Visit Function nodes
Stream<String> visitFunction(RulesContext context, AstNode node) async* {
  yield 'function'.indent(context.indent);
}
