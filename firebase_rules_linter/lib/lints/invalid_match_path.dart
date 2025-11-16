import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:firebase_rules_linter/util.dart';
import 'package:meta/meta.dart';

/// Lint for too many wildcards in match paths
class InvalidMatchPath extends AnalysisRule {
  /// invalid_match_path
  static const code = LintCode(
    'invalid_match_path',
    'Match paths can have at most one wildcard',
    severity: DiagnosticSeverity.ERROR,
  );

  /// Constructor
  InvalidMatchPath() : super(name: code.name, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addInstanceCreationExpression(this, visitor);
  }
}

@immutable
class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final type = node.staticType;
    if (type == null) return;

    final isFirebaseMatch = firebaseMatchChecker.isAssignableFromType(type);
    final isDatabaseMatch = databaseMatchChecker.isAssignableFromType(type);

    if (!isFirebaseMatch && !isDatabaseMatch) return;

    final arguments = node.argumentList.arguments;
    final path = resolveMatchPath(arguments: arguments);
    if (path == null) return;

    final wildcards = RegExp(
      isFirebaseMatch ? r'{(\w+)}' : r'\$(\w+)',
    ).allMatches(path);
    if (wildcards.length > 1) {
      rule.reportAtNode(arguments.first);
    }
  }
}
