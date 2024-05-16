import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Lint for avoiding raw rules
class AvoidRawRules extends DartLintRule {
  static const _code = LintCode(
    name: 'avoid_raw_rules',
    problemMessage:
        'Do not use raw rules unless necessary. Please create a GitHub issue for this use-case.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  /// Type checker for `RulesMethods`
  static const rulesMethodsTypeChecker =
      TypeChecker.fromName('RulesMethods', packageName: 'firebase_rules');

  /// Constructor
  const AvoidRawRules() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      final targetType = node.target?.staticType;
      if (targetType == null ||
          node.methodName.name != 'raw' ||
          !rulesMethodsTypeChecker.isExactlyType(targetType)) return;

      reporter.atNode(node, _code);
    });
  }
}
