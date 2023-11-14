import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/lints/avoid_raw_rules.dart';
import 'package:firebase_rules_linter/lints/invalid_match_function.dart';
import 'package:firebase_rules_linter/lints/invalid_match_path.dart';
import 'package:firebase_rules_linter/lints/undeclared_enum.dart';

/// Create the linter plugin
PluginBase createPlugin() => _FirebaseRulesLinter();

class _FirebaseRulesLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        AvoidRawRules(),
        InvalidMatchFunction(),
        InvalidMatchPath(),
        UndeclaredEnum(),
      ];
}

// TODO: Undeclared enum
// TODO: Undeclared function
// TODO: Invalid function call (calling a function on a non-rules type)