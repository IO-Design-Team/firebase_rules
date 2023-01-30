import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/common/generator.dart';
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
    checkValidity(element);

    final revived = reviveAnnotation(annotation);

    final buffer = StringBuffer();
    buffer.writeln('rules_version = \'${revived.rulesVersion}\';');
    buffer.writeln('service ${revived.service} {');

    // Generate functions
    final resolver = buildStep.resolver;
    final functionAnnotations =
        library.annotatedWith(TypeChecker.fromRuntime(RulesFunction));

    final context = Context.root(library, resolver);
    for (final annotation in functionAnnotations) {
      final ast = await resolver.astNodeFor(annotation.element);
      ast as FunctionDeclaration;
      await for (final line in visitFunction(context, ast)) {
        buffer.writeln(line);
      }
    }

    await for (final line
        in visitMatches(context, element, resolver, visitMatch)) {
      buffer.writeln(line);
    }

    buffer.writeln('}');
    return sanitizeRules(revived, buffer.toString());
  }

  /// Reconstruct the [FirebaseRules] object from the annotation
  FirebaseRules reviveAnnotation(ConstantReader annotation) {
    return FirebaseRules(
      rulesVersion: annotation.read('rulesVersion').stringValue,
      service: readEnum(annotation.read('service'), Service.values)!,
    );
  }
}
