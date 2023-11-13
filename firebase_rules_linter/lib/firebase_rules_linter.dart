// This is the entrypoint of our custom linter
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Create the linter plugin
PluginBase createPlugin() => _FirebaseRulesLinter();

class _FirebaseRulesLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        InvalidMatchFunctionSignature(),
      ];
}

/// Lint for invalid match function signatures
class InvalidMatchFunctionSignature extends DartLintRule {
  /// Metadata about the warning that will show-up in the IDE.
  /// This is used for `// ignore: code` and enabling/disabling the lint
  static const _code = LintCode(
    name: 'invalid_match_function_signature',
    problemMessage: 'The given function does not have the required signature',
  );

  /// Constructor
  const InvalidMatchFunctionSignature() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.staticType!.element!.name != 'Match') return;
      reporter.reportErrorForNode(code, node);
    });
  }
}

// TODO: Convert dart types to rules types
// TODO: Undeclared enum
// TODO: Undeclared function
// TODO: Avoid raws