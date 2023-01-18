import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Information about the current rules context
class RulesContext {
  /// Reader for the library running code generation
  final LibraryReader library;

  /// The resolver
  final Resolver resolver;

  /// All paths available in the current context
  final Set<String> paths;

  /// All functions available in the current context
  final Set<String> functions;

  /// The current indentation level
  final int indent;

  RulesContext._(
    this.library,
    this.resolver, {
    required this.paths,
    required this.functions,
    required this.indent,
  });

  /// Create the root context
  RulesContext.root(this.library, this.resolver)
      : paths = {},
        functions = {},
        indent = 0;

  /// Dive deeper into the context with additional indentation, paths, and functions
  RulesContext dive({Set<String>? paths, Set<String>? functions}) =>
      RulesContext._(
        library,
        resolver,
        paths: {...this.paths, ...?paths},
        functions: {...this.functions, ...?functions},
        indent: indent + 2,
      );
}
