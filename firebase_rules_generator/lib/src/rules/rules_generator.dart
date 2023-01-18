import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:firebase_rules_generator/src/rules/visitor/match_visitor.dart';
import 'package:source_gen/source_gen.dart';

/// Generate Firebase rules from a list of [Match] objects
class RulesGenerator extends GeneratorForAnnotation<FirebaseRules> {
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
    if (!isValidElement(element)) {
      throw InvalidGenerationSourceError(
        'The annotated element must be a List<Match>',
        element: element,
      );
    }

    final resolver = buildStep.resolver;
    final ast = await resolver.astNodeFor(element);
    final list = ast!.childEntities.whereType<ListLiteral>().single;
    final context = RulesContext.root(library!, resolver);

    // The generator adds extra line breaks if you return a stream
    final buffer = StringBuffer();
    for (final element in list.elements) {
      await for (final line in visitMatch(context, element)) {
        buffer.writeln(line);
      }
    }
    return buffer.toString();
  }

  /// Check that the element is a List<Match>
  bool isValidElement(Element element) {
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
}
