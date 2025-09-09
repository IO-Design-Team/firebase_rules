import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/util.dart';

/// Lint for using set literals in Firebase rules
class NoSetLiterals extends DartLintRule {
  static const _code = LintCode(
    name: 'no_set_literals',
    problemMessage: 'The rules language does not support set literals',
    correctionMessage:
        'Use a list literal instead. Ex: [1, 2, 3].rules().toSet()',
    errorSeverity: DiagnosticSeverity.ERROR,
  );

  static const _setChecker = TypeChecker.fromName('Set');

  /// Constructor
  const NoSetLiterals() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) async {
    final annotation = await getFirebaseRulesAnnotation(resolver);
    // This isn't a rules file
    if (annotation == null) return;

    context.registry.addSetOrMapLiteral((node) {
      final type = node.staticType;
      if (type == null) return;

      final isSet = _setChecker.isAssignableFromType(type);
      if (!isSet) return;

      final elements = node.elements.join(', ');
      reporter.atNode(node, _code, data: '[$elements]');
    });
  }

  @override
  List<Fix> getFixes() => [_UseListLiteralFix()];
}

class _UseListLiteralFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    Diagnostic analysisError,
    List<Diagnostic> others,
  ) {
    context.registry.addSetOrMapLiteral((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final builder = reporter.createChangeBuilder(
        message: 'Use a list literal instead',
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
