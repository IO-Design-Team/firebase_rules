import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

/// Information about the current rules context
class Context {
  /// The resolver
  final Resolver resolver;

  /// All paths available in the current context
  final Set<String> paths;

  /// The current indentation level
  final int indent;

  Context._(
    this.resolver, {
    required this.paths,
    required this.indent,
  });

  /// Create the root context
  Context.root(this.resolver)
      : paths = {},
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
  Context dive({bool clean = false, Set<String>? paths}) {
    final newPaths = {
      if (!clean) ...this.paths,
      ...?paths?.where((e) => e != '_'),
    };
    return Context._(
      resolver,
      paths: newPaths,
      indent: indent + 2,
    );
  }
}
