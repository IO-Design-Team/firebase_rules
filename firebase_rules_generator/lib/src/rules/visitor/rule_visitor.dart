import 'package:analyzer/dart/ast/ast.dart';

/// Visit Rule elements
Stream<String> visitRule(AstNode node) async* {
  yield 'rule1';
  yield 'rule2';
  yield 'rule3';
  yield 'rule4';
  yield 'rule5';
  yield 'rule';
  yield 'rule';
  yield 'rule';
  yield 'rule';
  yield 'rule';
}
