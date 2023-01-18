import 'package:analyzer/dart/ast/ast.dart';
import 'package:firebase_rules_generator/src/util.dart';

/// Visit Rule elements
Stream<String> visitRule(
  AstNode node, {
  required int indent,
}) async* {
  yield 'rule'.indent(indent);
  yield 'rule'.indent(indent);
  yield 'rule'.indent(indent);
  yield 'rule'.indent(indent);
  yield 'rule'.indent(indent);
  yield 'rule'.indent(indent);
  yield 'rule'.indent(indent);
  yield 'rule'.indent(indent);
}
