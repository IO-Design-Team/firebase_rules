import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/util.dart';
import 'package:source_helper/source_helper.dart';

/// Lint to ensure that all enums have declared mappings
class UndeclaredEnumValue extends DartLintRule {
  static const _code = LintCode(
    name: 'undeclared_enum_value',
    problemMessage:
        'This enum value has no mapping. Declare enum conversion maps in the FirebaseRules annotation.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  /// Constructor
  const UndeclaredEnumValue() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    final annotation = await getFirebaseRulesAnnotation(resolver);
    // This isn't a rules file
    if (annotation == null) return;

    context.registry.addPrefixedIdentifier((node) {
      // This is kind of hacky, but I couldn't find a better way
      // This should match any possible enum value (ex TestEnum.a)
      final couldBeEnumValue =
          RegExp(r'^[A-Z_][A-Za-z0-9]*\.[a-z_][A-Za-z0-9]*$')
              .hasMatch(node.toSource());
      if (!couldBeEnumValue) return;

      final type = node.staticType;
      if (type == null ||
          !type.isEnum ||
          // Ignore built-in enums
          libraryTypeChecker.isAssignableFromType(type)) return;

      final enumMaps = annotation
          .getField('enums')
          ?.toListValue()
          ?.map((e) => e.toMapValue()!.cast<DartObject, DartObject>());
      if (enumMaps == null) {
        reporter.atNode(node, _code);
        return;
      }

      final keys = enumMaps.expand(
        (e) => e.keys.map((e) {
          final enumType = e.type;
          final enumValue = e.getField('_name')!.toStringValue();
          return '$enumType.$enumValue';
        }),
      );
      if (keys.contains(node.toSource())) return;

      reporter.atNode(node, _code);
    });
  }
}
