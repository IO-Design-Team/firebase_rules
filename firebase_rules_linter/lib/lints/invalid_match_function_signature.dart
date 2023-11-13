import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/util.dart';

/// Lint for invalid match function signatures
class InvalidMatchFunctionSignature extends DartLintRule {
  static const _code = LintCode(
    name: 'invalid_match_function_signature',
    problemMessage: 'The given function does not have the expected signature',
  );

  /// Constructor
  const InvalidMatchFunctionSignature() : super(code: _code);

  /// Validate the given function's signature
  ///
  /// Returns the expected signature if invalid
  String? validateSignature({
    required String path,
    required String wildcardMatcher,
    required FunctionExpression function,
    required String Function(String wildcard) createExpectedSignature,
  }) {
    final String expectedWildcardParameterName;
    final pathWildcards = RegExp(wildcardMatcher).allMatches(path);
    if (pathWildcards.length > 1) {
      // The path is invalid. This is handled by another lint.
      return null;
    } else if (pathWildcards.length == 1) {
      expectedWildcardParameterName = pathWildcards.single[1]!;
    } else {
      expectedWildcardParameterName = '_';
    }

    final expectedSignature =
        createExpectedSignature(expectedWildcardParameterName);
    final actualSignature = function.parameters.toString();
    if (expectedSignature != actualSignature) {
      return expectedSignature;
    }

    return null;
  }

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

      for (final parameter in {
        'matches',
        'rules',
        'read',
        'write',
        'validate',
      }) {
        final node = getNamedParameter(arguments: arguments, name: parameter);
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
          reporter.reportErrorForNode(
            code,
            node.parameters!,
            null,
            null,
            expectedSignature,
          );
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
    AnalysisError analysisError,
    List<AnalysisError> others,
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
