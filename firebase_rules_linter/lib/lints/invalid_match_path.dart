import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/util.dart';

/// Lint for too many wildcards in match paths
class InvalidMatchPath extends DartLintRule {
  static const _code = LintCode(
    name: 'invalid_match_path',
    problemMessage:
        'The given path is invalid. Match paths can have at most one wildcard.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  /// Constructor
  const InvalidMatchPath() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final type = node.staticType;
      if (type == null) return;

      final isFirebaseMatch = firebaseMatchChecker.isAssignableFromType(type);
      final isDatabaseMatch = databaseMatchChecker.isAssignableFromType(type);

      if (!isFirebaseMatch && !isDatabaseMatch) return;

      final arguments = node.argumentList.arguments;
      final path = resolveMatchPath(arguments: arguments);
      if (path == null) return;

      final wildcards =
          RegExp(isFirebaseMatch ? r'{(\w+)}' : r'\$(\w+)').allMatches(path);
      if (wildcards.length > 1) {
        reporter.reportErrorForNode(_code, arguments.first);
      }
    });
  }
}
