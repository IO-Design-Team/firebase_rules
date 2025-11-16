import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:firebase_rules_linter/util.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

/// Lint for avoiding raw rules
class AvoidRawRules extends AnalysisRule {
  /// avoid_raw_rules
  static const code = LintCode(
    'avoid_raw_rules',
    'Do not use raw rules unless necessary. Please create a GitHub issue for this use-case.',
    severity: DiagnosticSeverity.WARNING,
  );

  /// Constructor
  AvoidRawRules() : super(name: code.name, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addMethodInvocation(this, visitor);
  }
}

@immutable
class _Visitor extends SimpleAstVisitor<void> {
  /// Type checker for `RulesMethods`
  static const rulesMethodsTypeChecker = TypeChecker.typeNamed(
    TypeNamed('RulesMethods'),
    inPackage: 'firebase_rules',
  );

  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final targetType = node.target?.staticType;
    if (targetType == null ||
        node.methodName.name != 'raw' ||
        !rulesMethodsTypeChecker.isExactlyType(targetType)) {
      return;
    }

    rule.reportAtNode(node);
  }
}
