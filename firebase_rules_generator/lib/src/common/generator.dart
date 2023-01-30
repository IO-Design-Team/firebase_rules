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
  void checkValidity(Element element) {
    if (!_isValidRules(element)) {
      throw InvalidGenerationSourceError(
        'The annotated element must be a List<Match>',
        element: element,
      );
    }
  }

  /// Check that the element is a List<Match>
  bool _isValidRules(Element element) {
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

  /// Visit all the matches in the list
  Stream<String> visitMatches(
    Context context,
    Element element,
    Resolver resolver,
    Stream<String> Function(Context, AstNode) visit,
  ) async* {
    final ast = await resolver.astNodeFor(element);
    final matches = ast!.childEntities.whereType<ListLiteral>().single.elements;

    for (final match in matches) {
      await for (final line in visit(context, match)) {
        yield line;
      }
    }
  }
}
