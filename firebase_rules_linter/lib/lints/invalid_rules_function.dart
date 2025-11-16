import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:meta/meta.dart';

/// Lint to ensure that all enums have declared mappings
class InvalidRulesFunction extends AnalysisRule {
  /// invalid_rules_function
  static const code = LintCode(
    'invalid_rules_function',
    'Rules functions must have positional parameters',
    severity: DiagnosticSeverity.ERROR,
  );

  /// Constructor
  InvalidRulesFunction()
    : super(name: code.name, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addFunctionDeclaration(this, visitor);
  }
}

@immutable
class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final parameters = node.functionExpression.parameters;
    if (parameters == null) return;

    final parameterFragments = parameters.parameterFragments
        .whereType<FormalParameterFragment>();
    if (parameterFragments.where((e) => e.element.isNamed).isNotEmpty) {
      rule.reportAtNode(parameters);
      return;
    }
  }
}
