import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Information about the current rules context
class Context {
  /// Reader for the library running code generation
  final LibraryReader library;

  /// The resolver
  final Resolver resolver;

  /// All paths available in the current context
  final Set<String> paths;

  /// The current indentation level
  final int indent;

  Context._(
    this.library,
    this.resolver, {
    required this.paths,
    required this.indent,
  });

  /// Create the root context
  Context.root(
    this.library,
    this.resolver,
  )   : paths = {},
        indent = 2;

  /// Dive deeper into the context with additional paths and indentation
  ///
  /// A clean dive will overwrite existing context
  Context dive({bool clean = false, Set<String>? paths}) {
    final newPaths = {
      if (!clean) ...this.paths,
      ...?paths,
    };
    return Context._(
      library,
      resolver,
      paths: newPaths,
      indent: indent + 2,
    );
  }
}
