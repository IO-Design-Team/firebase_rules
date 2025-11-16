import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:firebase_rules_linter/util.dart';
import 'package:meta/meta.dart';

/// Lint to ensure that all enums have declared mappings
class UndeclaredFunction extends AnalysisRule {
  /// undeclared_function
  static const code = LintCode(
    'undeclared_function',
    'Declare functions in the FirebaseRules annotation',
    severity: DiagnosticSeverity.ERROR,
  );

  /// Constructor
  UndeclaredFunction()
    : super(name: code.name, description: code.problemMessage);

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
  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final library = context.libraryElement;
    if (library == null) return;

    final annotation = getFirebaseRulesAnnotation(library);
    // This isn't a rules file
    if (annotation == null) return;

    if (node.childEntities.length != 2) return;
    final functionName = node.childEntities.first;
    if (functionName is! SimpleIdentifier) return;

    final functions = annotation
        .getField('functions')
        ?.toListValue()
        ?.map((e) => e.toFunctionValue()?.name)
        .nonNulls;
    if (functions != null && functions.contains(functionName.name)) {
      return;
    }

    rule.reportAtNode(functionName);
  }
}
