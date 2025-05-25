import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/database.dart';
import 'package:firebase_rules_generator/src/common/rules_context.dart';
import 'package:firebase_rules_generator/src/common/generator.dart';
import 'package:firebase_rules_generator/src/database/sanitizer.dart';
import 'package:firebase_rules_generator/src/database/visitor/match_visitor.dart';
import 'package:source_gen/source_gen.dart';

/// Generate Database rules from a list of [Match] objects
class DatabaseRulesGenerator extends GeneratorForAnnotation<DatabaseRules>
    with RulesGenerator {
  @override
  Future<String> generateForAnnotatedElement(
    /// TODO: Fix with analyzer 8
    /// ignore: deprecated_member_use
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    checkType(element);

    final buffer = StringBuffer();
    buffer.writeln('{');

    final resolver = buildStep.resolver;
    final ast = await resolver.astNodeFor(element);
    final matches = ast!.childEntities.whereType<ListLiteral>().single.elements;
    final context = RulesContext.root(resolver);

    for (final match in matches) {
      await for (final line in visitMatch(context, match)) {
        buffer.writeln(line);
      }
    }

    buffer.writeln('}');
    return sanitizeRules(buffer.toString());
  }
}
