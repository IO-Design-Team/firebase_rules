import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/lints/invalid_match_function_signature.dart';

/// Create the linter plugin
PluginBase createPlugin() => _FirebaseRulesLinter();

class _FirebaseRulesLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        InvalidMatchFunctionSignature(),
      ];
}


// TODO: Convert dart types to rules types
// TODO: Undeclared enum
// TODO: Undeclared function
// TODO: Avoid raws