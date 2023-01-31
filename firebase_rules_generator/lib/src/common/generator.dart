import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:firebase_rules_generator/src/common/context.dart';
import 'package:source_gen/source_gen.dart';

/// Base rules generator
abstract class RulesGenerator<T> extends GeneratorForAnnotation<T> {
  /// The library reader
  LibraryReader? _library;

  /// The library reader
  LibraryReader get library {
    final library = _library;
    if (library == null) {
      throw StateError('library is null');
    }
    return library;
  }

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    this._library = library;
    return super.generate(library, buildStep);
  }

  /// If the element is a List<Match>
  void checkType(Element element) {
    if (!_isMatchList(element)) {
      throw InvalidGenerationSourceError(
        'The annotated element must be a List<Match>',
        element: element,
      );
    }
  }

  /// Check that the element is a List<Match>
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
