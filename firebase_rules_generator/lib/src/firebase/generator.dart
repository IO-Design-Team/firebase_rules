import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:firebase_rules_generator/src/firebase/sanitizer.dart';
import 'package:firebase_rules_generator/src/firebase/util.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/function_visitor.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/match_visitor.dart';
import 'package:source_gen/source_gen.dart';

/// Generate Firebase rules from a list of [Match] objects
class FirebaseRulesGenerator extends GeneratorForAnnotation<FirebaseRules> {
  /// The library reader
  LibraryReader? library;

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    this.library = library;
    return super.generate(library, buildStep);
  }

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final library = this.library;
    if (library == null) {
      throw StateError('library is null');
    }

    if (!isValidFirebaseRules(element)) {
      throw InvalidGenerationSourceError(
        'The annotated element must be a List<Match>',
        element: element,
      );
    }

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

  /// Check that the element is a List<Match>
  bool isValidFirebaseRules(Element element) {
    element as TopLevelVariableElement;
    if (!element.type.isDartCoreList) {
      return false;
    }
    final classElement = (element.type as ParameterizedType)
        .typeArguments
        .single
        .element as ClassElement;
    return classElement.name == 'Match';
  }

  /// Reconstruct the [FirebaseRules] object from the annotation
  FirebaseRules reviveAnnotation(ConstantReader annotation) {
    return FirebaseRules(
      rulesVersion: annotation.read('rulesVersion').stringValue,
      service: readEnum(annotation.read('service'), Service.values)!,
    );
  }
}
