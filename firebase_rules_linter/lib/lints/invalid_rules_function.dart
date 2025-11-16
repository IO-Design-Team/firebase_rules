import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/util.dart';

/// Lint to ensure that all enums have declared mappings
class InvalidRulesFunction extends DartLintRule {
  static const _code = LintCode(
    name: 'invalid_rules_function',
    problemMessage: 'Rules functions must have positional parameters',
    errorSeverity: DiagnosticSeverity.ERROR,
  );

  /// Constructor
  const InvalidRulesFunction() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) async {
    final annotation = await getFirebaseRulesAnnotation(resolver);
    // This isn't a rules file
    if (annotation == null) return;

    context.registry.addFunctionDeclaration((node) {
      final parameters = node.functionExpression.parameters;
      if (parameters == null) return;

      final parameterFragments = parameters.parameterFragments
          .whereType<FormalParameterFragment>();
      if (parameterFragments.where((e) => e.element.isNamed).isNotEmpty) {
        reporter.atNode(parameters, _code);
        return;
      }
    });
  }
}
