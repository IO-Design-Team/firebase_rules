import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/database.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/generator.dart';
import 'package:firebase_rules_generator/src/database/sanitizer.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/match_visitor.dart';
import 'package:source_gen/source_gen.dart';

/// Generate Database rules from a list of [Match] objects
class DatabaseRulesGenerator extends RulesGenerator<DatabaseRules> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    checkValidity(element);

    final buffer = StringBuffer();

    // Generate functions
    final resolver = buildStep.resolver;
    final context = Context.root(library, resolver);
    await for (final line in visitMatches(context, element, resolver, visitMatch)) {
      buffer.writeln(line);
    }

    return sanitizeRules(buffer.toString());
  }
}
