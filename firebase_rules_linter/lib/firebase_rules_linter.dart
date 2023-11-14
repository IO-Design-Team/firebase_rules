import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:firebase_rules_linter/lints/avoid_raw_rules.dart';
import 'package:firebase_rules_linter/lints/invalid_match_function.dart';
import 'package:firebase_rules_linter/lints/invalid_match_path.dart';
import 'package:firebase_rules_linter/lints/invalid_rules_function.dart';
import 'package:firebase_rules_linter/lints/undeclared_enum.dart';
import 'package:firebase_rules_linter/lints/undeclared_function.dart';

/// Create the linter plugin
PluginBase createPlugin() => _FirebaseRulesLinter();

class _FirebaseRulesLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        AvoidRawRules(),
        InvalidMatchFunction(),
        InvalidMatchPath(),
        InvalidRulesFunction(),
        UndeclaredEnum(),
        UndeclaredFunction(),
      ];
}
