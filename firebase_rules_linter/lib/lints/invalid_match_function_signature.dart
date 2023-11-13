import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Lint for invalid match function signatures
class InvalidMatchFunctionSignature extends DartLintRule {
  static const _code = LintCode(
    name: 'invalid_match_function_signature',
    problemMessage: 'The given function does not have the required signature',
  );

  /// Constructor
  const InvalidMatchFunctionSignature() : super(code: _code);

  /// Get a parameter by name
  AstNode? getNamedParameter(
    Iterable<SyntacticEntity> arguments,
    String name,
  ) {
    return arguments
        .whereType<NamedExpression>()
        .firstWhereOrNull((e) => e.name.label.name == name)
        ?.expression;
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.staticType!.element!.name != 'Match') return;
      final arguments = node.argumentList.arguments;
    });
  }

  // @override
  // List<Fix> getFixes() => [_UseExpectedSignatureFix()];
}

// class _UseExpectedSignatureFix extends DartFix {
//   @override
//   void run(
//     CustomLintResolver resolver,
//     ChangeReporter reporter,
//     CustomLintContext context,
//     AnalysisError analysisError,
//     List<AnalysisError> others,
//   ) {
//     context.registry.addInstanceCreationExpression((node) {
//       if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

//       // We define one edit, giving it a message which will show-up in the IDE.
//       final changeBuilder = reporter.createChangeBuilder(
//         message: 'Make provider final',
//         // This represents how high-low should this quick-fix show-up in the list
//         // of quick-fixes.
//         priority: 1,
//       );

//       // Our edit will consist of editing a Dart file, so we invoke "addDartFileEdit".
//       // The changeBuilder variable also has utilities for other types of files.
//       changeBuilder.addDartFileEdit((builder) {
//         final nodeKeyword = node.keyword;
//         final nodeType = node.type;
//         if (nodeKeyword != null) {
//           // Replace "var x = ..." into "final x = ...""

//           // Using "builder", we can emit changes to a file.
//           // In this case, addSimpleReplacement is used to override a selection
//           // with a new content.
//           builder.addSimpleReplacement(
//             SourceRange(nodeKeyword.offset, nodeKeyword.length),
//             'final',
//           );
//         } else if (nodeType != null) {
//           // Replace "Type x = ..." into "final Type x = ..."

//           // Once again we emit an edit to our file.
//           // But this time, we add new content without replacing existing content.
//           builder.addSimpleInsertion(nodeType.offset, 'final ');
//         }
//       });
//     });
//   }
// }
