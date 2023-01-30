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

  /// The current indentation level
  final int indent;

  RulesContext._(
    this.library,
    this.resolver, {
    required this.paths,
    required this.indent,
  });

  /// Create the root context
  RulesContext.root(
    this.library,
    this.resolver,
  )   : paths = {},
        indent = 2;

  /// Dive deeper into the context with additional paths and indentation
  ///
  /// A clean dive will overwrite existing context
  RulesContext dive({bool clean = false, Set<String>? paths}) {
    final newPaths = {
      if (!clean) ...this.paths,
      ...?paths,
    };
    return RulesContext._(
      library,
      resolver,
      paths: newPaths,
      indent: indent + 2,
    );
  }
}
