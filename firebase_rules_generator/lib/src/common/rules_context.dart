import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

/// Information about the current rules context
class RulesContext {
  /// The resolver
  final Resolver resolver;

  /// All wildcards available in the current context
  final Set<String> wildcards;

  /// The current indentation level
  final int indent;

  /// Functions to write in this context
  ///
  /// Can only be set in the root context
  final Iterable<ExecutableElement> functions;

  RulesContext._(
    this.resolver, {
    required this.wildcards,
    required this.indent,
  }) : functions = const [];

  /// Create the root context
  RulesContext.root(
    this.resolver, {
    this.functions = const [],
  })  : wildcards = {},
        indent = 2;

  /// Get the first resolvable element with the given [name] and type [T]
  Future<T> get<T extends Element>(String name) {
    return resolver.libraries
        .expand((e) => e.topLevelElements.where((e) => e.name == name))
        .where((e) => e is T)
        .cast<T>()
        .first;
  }

  /// Dive deeper into the context with additional wildcards and indentation
  ///
  /// A clean dive will overwrite existing context
  RulesContext dive({bool clean = false, Set<String>? wildcards}) {
    final newWildcards = {
      if (!clean) ...this.wildcards,
      ...?wildcards?.where((e) => e != '_'),
    };
    return RulesContext._(
      resolver,
      wildcards: newWildcards,
      indent: indent + 2,
    );
  }
}
