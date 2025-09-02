import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

/// Base rules generator
mixin RulesGenerator {
  /// If the element is a `List<Match>`
  void checkType(Element2 element) {
    if (!_isMatchList(element)) {
      throw InvalidGenerationSourceError(
        'The annotated element must be a List<Match>',
        element: element,
      );
    }
  }

  /// Check that the element is a `List<Match>`
  bool _isMatchList(Element2 element) {
    element as TopLevelVariableElement2;
    if (!element.type.isDartCoreList) {
      return false;
    }
    final classElement = (element.type as ParameterizedType)
        .typeArguments
        .single
        .element3 as ClassElement2;
    return classElement.name3 == 'Match';
  }
}
