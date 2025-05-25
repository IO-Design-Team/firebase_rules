import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

/// Base rules generator
mixin RulesGenerator {
  /// If the element is a `List<Match>`
  /// TODO: Fix with analyzer 8
  /// ignore: deprecated_member_use
  void checkType(Element element) {
    if (!_isMatchList(element)) {
      throw InvalidGenerationSourceError(
        'The annotated element must be a List<Match>',
        element: element,
      );
    }
  }

  /// Check that the element is a `List<Match>`
  /// TODO: Fix with analyzer 8
  /// ignore: deprecated_member_use
  bool _isMatchList(Element element) {
    /// TODO: Fix with analyzer 8
    /// ignore: deprecated_member_use
    element as TopLevelVariableElement;
    if (!element.type.isDartCoreList) {
      return false;
    }
    final classElement = (element.type as ParameterizedType)
        .typeArguments
        .single

        /// TODO: Fix with analyzer 8
        /// ignore: deprecated_member_use
        .element as ClassElement;
    return classElement.name == 'Match';
  }
}
