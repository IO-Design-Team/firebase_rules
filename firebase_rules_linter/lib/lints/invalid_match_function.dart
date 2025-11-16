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
import 'package:collection/collection.dart';
import 'package:firebase_rules_linter/util.dart';
import 'package:meta/meta.dart';

/// Lint for invalid match function signatures
class InvalidMatchFunction extends AnalysisRule {
  /// invalid_match_function
  static const code = LintCode(
    '`invalid_match_function`',
    'The given function does not have the expected signature',
    severity: DiagnosticSeverity.ERROR,
  );

  /// Constructor
  InvalidMatchFunction()
    : super(name: code.name, description: code.problemMessage);

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

/// Validate the given function's signature
///
/// Returns the expected signature if invalid
String? _validateSignature({
  required String path,
  required FunctionExpression function,
  required bool isFirebaseMatch,
}) {
  final String expectedWildcard;
  final wildcards = RegExp(
    isFirebaseMatch ? r'{(\w+)}' : r'\$(\w+)',
  ).allMatches(path);
  if (wildcards.length > 1) {
    // The path is invalid. This is handled by another lint.
    return null;
  } else if (wildcards.length == 1) {
    expectedWildcard = wildcards.single[1] ?? '_';
  } else {
    expectedWildcard = '_';
  }

  final expectedSignature = isFirebaseMatch
      ? '($expectedWildcard, request, resource)'
      : '($expectedWildcard)';
  final actualSignature = function.parameters.toString();
  if (expectedSignature != actualSignature) {
    return expectedSignature;
  }

  return null;
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

    for (final parameter in {'matches', 'rules', 'read', 'write', 'validate'}) {
      final function = arguments
          .whereType<NamedExpression>()
          .firstWhereOrNull((e) => e.name.label.name == parameter)
          ?.expression;
      if (function == null || function is! FunctionExpression) continue;

      final expectedSignature = _validateSignature(
        path: path,
        function: function,
        isFirebaseMatch: isFirebaseMatch,
      );
      if (expectedSignature != null) {
        rule.reportAtNode(function.parameters);
      }
    }
  }
}

/// Fix for `invalid_match_function`
class UseExpectedSignature extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'firebase_rules_linter.fix.useExpectedSignature',
    DartFixKindPriority.standard,
    'Use expected signature',
  );

  /// Constructor
  UseExpectedSignature({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final function = node.parent;
    final match = function?.parent?.parent;
    if (function == null ||
        match == null ||
        function is! FunctionExpression ||
        match is! InstanceCreationExpression) {
      return;
    }

    final matchType = match.staticType;
    if (matchType == null) return;

    final isFirebaseMatch = firebaseMatchChecker.isAssignableFromType(
      matchType,
    );

    final path = resolveMatchPath(arguments: match.argumentList.arguments);
    if (path == null) return;

    final expectedSignature = _validateSignature(
      path: path,
      function: function,
      isFirebaseMatch: isFirebaseMatch,
    );

    if (expectedSignature == null) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(range.entity(node), expectedSignature);
    });
  }
}
