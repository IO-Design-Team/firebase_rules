import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

/// Information about the current rules context
class RulesContext {
  /// The resolver
  final Resolver resolver;

  /// All paths available in the current context
  final Set<String> paths;

  /// The current indentation level
  final int indent;

  /// Functions to write in this context
  ///
  /// Can only be set in the root context
  final Iterable<ExecutableElement> functions;

  RulesContext._(
    this.resolver, {
    required this.paths,
    required this.indent,
  }) : functions = const [];

  /// Create the root context
  RulesContext.root(
    this.resolver, {
    this.functions = const [],
  })  : paths = {},
        indent = 2;

  /// Get the first resolvable element with the given [name] and type [T]
  Future<T> get<T extends Element>(String name) {
    return resolver.libraries
        .expand((e) => e.topLevelElements.where((e) => e.name == name))
        .where((e) => e is T)
        .cast<T>()
        .first;
  }

  /// Dive deeper into the context with additional paths and indentation
  ///
  /// A clean dive will overwrite existing context
  RulesContext dive({bool clean = false, Set<String>? paths}) {
    final newPaths = {
      if (!clean) ...this.paths,
      ...?paths?.where((e) => e != '_'),
    };
    return RulesContext._(
      resolver,
      paths: newPaths,
      indent: indent + 2,
    );
  }
}
