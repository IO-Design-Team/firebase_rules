import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/util.dart';

/// Lint for invalid match function signatures
class InvalidMatchFunction extends DartLintRule {
  static const _code = LintCode(
    name: 'invalid_match_function',
    problemMessage: 'The given function does not have the expected signature',
    errorSeverity: DiagnosticSeverity.ERROR,
  );

  /// Constructor
  const InvalidMatchFunction() : super(code: _code);

  /// Validate the given function's signature
  ///
  /// Returns the expected signature if invalid
  String? validateSignature({
    required String path,
    required String wildcardMatcher,
    required FunctionExpression function,
    required String Function(String wildcard) createExpectedSignature,
  }) {
    final String expectedWildcard;
    final wildcards = RegExp(wildcardMatcher).allMatches(path);
    if (wildcards.length > 1) {
      // The path is invalid. This is handled by another lint.
      return null;
    } else if (wildcards.length == 1) {
      expectedWildcard = wildcards.single[1]!;
    } else {
      expectedWildcard = '_';
    }

    final expectedSignature = createExpectedSignature(expectedWildcard);
    final actualSignature = function.parameters.toString();
    if (expectedSignature != actualSignature) {
      return expectedSignature;
    }

    return null;
  }

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
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

      for (final parameter in {
        'matches',
        'rules',
        'read',
        'write',
        'validate',
      }) {
        final node = arguments
            .whereType<NamedExpression>()
            .firstWhereOrNull((e) => e.name.label.name == parameter)
            ?.expression;
        if (node == null || node is! FunctionExpression) continue;

        final expectedSignature = validateSignature(
          path: path,
          wildcardMatcher: isFirebaseMatch ? r'{(\w+)}' : r'\$(\w+)',
          function: node,
          createExpectedSignature: (wildcard) => isFirebaseMatch
              ? '($wildcard, request, resource)'
              : '($wildcard)',
        );
        if (expectedSignature != null) {
          reporter.atNode(node.parameters!, code, data: expectedSignature);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [_UseExpectedSignatureFix()];
}

class _UseExpectedSignatureFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    Diagnostic analysisError,
    List<Diagnostic> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final builder = reporter.createChangeBuilder(
        message: 'Use expected signature',
        priority: 1,
      );

      builder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          analysisError.sourceRange,
          analysisError.data as String,
        );
      });
    });
  }
}
