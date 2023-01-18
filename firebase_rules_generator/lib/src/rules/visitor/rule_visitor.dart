import 'package:analyzer/dart/ast/ast.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:firebase_rules_generator/src/util.dart';

/// Visit Rule nodes
Stream<String> visitRule(RulesContext context, AstNode node) async* {
  yield 'rule'.indent(context.indent);
  yield 'rule'.indent(context.indent);
  yield 'rule'.indent(context.indent);
  yield 'rule'.indent(context.indent);
  yield 'rule'.indent(context.indent);
  yield 'rule'.indent(context.indent);
  yield 'rule'.indent(context.indent);
  yield 'rule'.indent(context.indent);
}
