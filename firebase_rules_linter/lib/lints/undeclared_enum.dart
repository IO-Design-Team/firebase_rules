import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class UndeclaredEnum extends DartLintRule {
  static const _code = LintCode(
    name: 'undeclared_enum',
    problemMessage: 'This enum is undeclared. Add it to a parent Match.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  /// Constructor
  const UndeclaredEnum() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addSimpleIdentifier((node) {
      final type = node.staticType;
      if (type == null || !type.isDartCoreEnum) return;

      reporter.reportErrorForNode(_code, node);
    });
  }
}
