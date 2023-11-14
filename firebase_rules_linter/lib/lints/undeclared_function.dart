import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/util.dart';

/// Lint to ensure that all enums have declared mappings
class UndeclaredFunction extends DartLintRule {
  static const _code = LintCode(
    name: 'undeclared_function',
    problemMessage: 'This function is undeclared. Add it to the annotation.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  /// Constructor
  const UndeclaredFunction() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    final resolved = await resolver.getResolvedUnitResult();

    context.registry.addFunctionDeclaration((node) {
      final annotation = getFirebaseRulesAnnotation(resolved);
      // This isn't a rules file
      if (annotation == null) return;

      final functions = annotation
          .getField('functions')
          ?.toListValue()
          ?.map((e) => e.toFunctionValue()!.name);
      if (functions == null) {
        reporter.reportErrorForNode(_code, node);
        return;
      }

      if (functions.contains(node.name.toString())) return;

      reporter.reportErrorForNode(_code, node);
    });
  }
}
