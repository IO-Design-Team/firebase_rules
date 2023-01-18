import 'dart:mirrors';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:firebase_rules_generator/src/rules/src/match_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Generate Firebase rules from a list of [Match] objects
class RulesGenerator extends GeneratorForAnnotation<FirebaseRules> {
  static final _matchClassName =
      MirrorSystem.getName(reflectClass(Match().runtimeType).simpleName);

  @override
  Iterable<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) sync* {
    if (!isValidElement(element)) {
      throw InvalidGenerationSourceError(
        'The annotated element must be a List<Match>',
        element: element,
      );
    }

    final tlve = element as TopLevelVariableElement;
    final asdf = tlve.value
    // final matches =

    // for () {
    //   final matchElement = match as ClassElement;
    //   final matchGenerator = MatchGenerator(matchElement);
    //   yield* matchGenerator.generate();
    // }
  }

  /// Check that
  bool isValidElement(Element element) {
    final tlve = element as TopLevelVariableElement;
    if (!tlve.type.isDartCoreList) {
      return false;
    }
    final classElement = (tlve.type as ParameterizedType)
        .typeArguments
        .single
        .element as ClassElement;
    return classElement.name == _matchClassName;
  }
}
