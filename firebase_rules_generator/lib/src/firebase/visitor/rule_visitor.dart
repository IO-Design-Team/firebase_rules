import 'package:analyzer/dart/ast/ast.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/firebase/sanitizer.dart';
import 'package:firebase_rules_generator/src/common/util.dart';

/// Visit Rule nodes
Stream<String> visitRule(Context context, AstNode node) async* {
  final arguments =
      node.childEntities.whereType<ArgumentList>().single.arguments;
  final operationIdentifiers = arguments[0] as ListLiteral;
  final operations = operationIdentifiers.elements
      .cast<PrefixedIdentifier>()
      .map((e) => e.identifier.name);
  final condition = sanitizePaths(context, arguments[1].toSource());

  yield 'allow ${operations.join(', ')}: if $condition;'.indent(context.indent);
}
