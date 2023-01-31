import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/generator.dart';
import 'package:firebase_rules_generator/src/firebase/revived_firebase_rules.dart';
import 'package:firebase_rules_generator/src/firebase/sanitizer.dart';
import 'package:firebase_rules_generator/src/firebase/util.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/function_visitor.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/match_visitor.dart';
import 'package:source_gen/source_gen.dart';

/// Generate Firebase rules from a list of [Match] objects
class FirebaseRulesGenerator extends RulesGenerator<FirebaseRules> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    checkType(element);

    final revived = reviveAnnotation(annotation);

    final buffer = StringBuffer();
    buffer.writeln('rules_version = \'${revived.rulesVersion}\';');
    buffer.writeln('service ${revived.service} {');

    // Generate functions
    final resolver = buildStep.resolver;
    final context = Context.root(library, resolver);
    for (final function in revived.functions) {
      final ast = await resolver.astNodeFor(function);
      ast as FunctionDeclaration;
      await for (final line in visitFunction(context, ast)) {
        buffer.writeln(line);
      }
    }

    final ast = await resolver.astNodeFor(element);
    final matches = ast!.childEntities.whereType<ListLiteral>().single.elements;

    for (final match in matches) {
      await for (final line in visitMatch(context, match)) {
        buffer.writeln(line);
      }
    }

    buffer.writeln('}');
    return sanitizeRules(revived, buffer.toString());
  }

  /// Reconstruct the [FirebaseRules] object from the annotation
  RevivedFirebaseRules reviveAnnotation(ConstantReader annotation) {
    return RevivedFirebaseRules(
      rulesVersion: annotation.read('rulesVersion').stringValue,
      service: readEnum(annotation.read('service'), Service.values)!,
      functions: annotation
          .read('functions')
          .listValue
          .map((e) => e.toFunctionValue()! as FunctionElement)
          .toList(),
    );
  }
}
