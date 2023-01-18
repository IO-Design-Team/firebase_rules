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

  /// If true, print debug information
  final bool debug;

  RulesContext._(
    this.library,
    this.resolver, {
    required this.paths,
    required this.functions,
    required this.indent,
    required this.debug,
  });

  /// Create the root context
  RulesContext.root(this.library, this.resolver, {this.debug = false})
      : paths = {},
        functions = {},
        indent = 0;

  /// Dive deeper into the context with additional paths, functions, and indentation
  RulesContext dive({
    Set<String>? paths,
    Set<String>? functions,
  }) {
    final newPaths = {...this.paths, ...?paths};
    final newFunctions = {...this.functions, ...?functions};
    print('Diving:\n  paths: $newPaths\n  functions: $functions');
    return RulesContext._(
      library,
      resolver,
      paths: newPaths,
      functions: newFunctions,
      indent: indent + 2,
      debug: debug,
    );
  }
}
