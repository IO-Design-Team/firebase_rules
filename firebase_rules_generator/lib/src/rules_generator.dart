import 'dart:mirrors';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:source_gen/source_gen.dart';

/// Generate Firebase rules from a list of [Match] objects
class RulesGenerator extends GeneratorForAnnotation<FirebaseRules> {
  static final _matchClassName =
      MirrorSystem.getName(reflectClass(Match().runtimeType).simpleName);

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (!isValidElement(element)) {
      throw InvalidGenerationSourceError(
        'The annotated element must be a List<Match>',
        element: element,
      );
    }
    return 'This is a test';
  }

  /// Check that
  bool isValidElement(Element element) {
    final tlve = element as TopLevelVariableElement;
    if (!tlve.type.isDartCoreList) {
      return false;
    }
    // check that the list type is Match
    final listType = tlve.type as ParameterizedType;
    final classElement = listType.typeArguments.single.element as ClassElement;
    return classElement.name == _matchClassName;
  }
}
