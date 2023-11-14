import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/util.dart';
import 'package:source_helper/source_helper.dart';

/// Lint to ensure that all enums have declared mappings
class UndeclaredEnum extends DartLintRule {
  static const _code = LintCode(
    name: 'undeclared_enum',
    problemMessage:
        'Declare enum conversion maps in the FirebaseRules annotation',
    errorSeverity: ErrorSeverity.ERROR,
  );

  /// Constructor
  const UndeclaredEnum() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    final resolved = await resolver.getResolvedUnitResult();

    context.registry.addSimpleIdentifier((node) {
      final type = node.staticType;
      if (type == null ||
          !type.isEnum ||
          // Ignore built-in enums
          libraryTypeChecker.isAssignableFromType(type)) return;

      final annotation = getFirebaseRulesAnnotation(resolved);
      // This isn't a rules file
      if (annotation == null) return;

      final enumMaps = annotation
          .getField('enums')
          ?.toListValue()
          ?.map((e) => e.toMapValue()!.cast<DartObject, DartObject>());
      if (enumMaps == null) {
        reporter.reportErrorForNode(_code, node);
        return;
      }

      final types = enumMaps.map((e) => e.keys.firstOrNull?.type);
      if (types.contains(type)) return;

      reporter.reportErrorForNode(_code, node);
    });
  }
}
