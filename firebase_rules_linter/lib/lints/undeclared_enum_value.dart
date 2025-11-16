import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/error/error.dart';
import 'package:firebase_rules_linter/util.dart';
import 'package:meta/meta.dart';
import 'package:source_helper/source_helper.dart';

/// Lint to ensure that all enums have declared mappings
class UndeclaredEnumValue extends AnalysisRule {
  /// undeclared_enum_value
  static const code = LintCode(
    'undeclared_enum_value',
    'This enum value has no mapping. Declare enum conversion maps in the FirebaseRules annotation.',
    severity: DiagnosticSeverity.ERROR,
  );

  /// Constructor
  UndeclaredEnumValue()
    : super(name: code.name, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addPrefixedIdentifier(this, visitor);
  }
}

@immutable
class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    final library = context.libraryElement;
    if (library == null) return;

    final annotation = getFirebaseRulesAnnotation(library);
    // This isn't a rules file
    if (annotation == null) return;

    // This is kind of hacky, but I couldn't find a better way
    // This should match any possible enum value (ex TestEnum.a)
    final couldBeEnumValue = RegExp(
      r'^[A-Z_][A-Za-z0-9]*\.[a-z_][A-Za-z0-9]*$',
    ).hasMatch(node.toSource());
    if (!couldBeEnumValue) return;

    final type = node.staticType;
    final libraryUri = type?.element?.library?.uri;

    if (type == null ||
        !type.isEnum ||
        // Ignore built-in enums
        libraryUri == null ||
        libraryUri.toString().startsWith('package:firebase_rules/')) {
      return;
    }

    final enumMaps = annotation
        .getField('enums')
        ?.toListValue()
        ?.map((e) => e.toMapValue()?.cast<DartObject, DartObject>())
        .nonNulls;
    if (enumMaps == null) {
      rule.reportAtNode(node);
      return;
    }

    final keys = enumMaps.expand(
      (e) => e.keys.map((e) {
        final enumType = e.type;
        final enumValue = e.getField('_name')?.toStringValue();
        return '$enumType.$enumValue';
      }),
    );
    if (keys.contains(node.toSource())) return;

    rule.reportAtNode(node);
  }
}
