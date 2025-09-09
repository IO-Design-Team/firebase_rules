import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

/// Base rules generator
mixin RulesGenerator {
  /// If the element is a `List<Match>`
  void checkType(Element element) {
    if (!_isMatchList(element)) {
      throw InvalidGenerationSourceError(
        'The annotated element must be a List<Match>',
        element: element,
      );
    }
  }

  /// Check that the element is a `List<Match>`
  bool _isMatchList(Element element) {
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
