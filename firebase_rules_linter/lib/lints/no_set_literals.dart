import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:firebase_rules_linter/util.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

/// Lint for using set literals in Firebase rules
class NoSetLiterals extends AnalysisRule {
  /// no_set_literals
  static const code = LintCode(
    'no_set_literals',
    'The rules language does not support set literals',
    correctionMessage:
        'Use a list literal instead. Ex: [1, 2, 3].rules().toSet()',
    severity: DiagnosticSeverity.ERROR,
  );

  /// Constructor
  NoSetLiterals() : super(name: code.name, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addSetOrMapLiteral(this, visitor);
  }
}

@immutable
class _Visitor extends SimpleAstVisitor<void> {
  static const _setChecker = TypeChecker.typeNamed(
    Set,
    inPackage: 'core',
    inSdk: true,
  );

  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    final library = context.libraryElement;
    if (library == null) return;

    final annotation = getFirebaseRulesAnnotation(library);
    // This isn't a rules file
    if (annotation == null) return;

    final type = node.staticType;
    if (type == null) return;

    final isSet = _setChecker.isAssignableFromType(type);
    if (!isSet) return;

    rule.reportAtNode(node);
  }
}

/// Fix for `no_set_literals`
class UseListLiteral extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'firebase_rules_linter.fix.useListLiteral',
    DartFixKindPriority.standard,
    'Use a list literal instead',
  );

  /// Constructor
  UseListLiteral({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! SetOrMapLiteral) return;

    final elements = node.elements.join(', ');

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(range.entity(node), '[$elements]');
    });
  }
}
