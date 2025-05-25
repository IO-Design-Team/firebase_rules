import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/util.dart';

/// Lint to ensure that all enums have declared mappings
class UndeclaredFunction extends DartLintRule {
  static const _code = LintCode(
    name: 'undeclared_function',
    problemMessage: 'Declare functions in the FirebaseRules annotation',
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
    final annotation = await getFirebaseRulesAnnotation(resolver);
    // This isn't a rules file
    if (annotation == null) return;

    context.registry.addMethodInvocation((node) {
      if (node.childEntities.length != 2) return;
      final functionName = node.childEntities.first;
      if (functionName is! SimpleIdentifier) return;

      final functions = annotation
          .getField('functions')
          ?.toListValue()

          /// TODO: Fix with analyzer 8
          /// ignore: deprecated_member_use
          ?.map((e) => e.toFunctionValue()!.name);
      if (functions != null && functions.contains(functionName.name)) {
        return;
      }

      reporter.atNode(functionName, _code);
    });
  }
}
