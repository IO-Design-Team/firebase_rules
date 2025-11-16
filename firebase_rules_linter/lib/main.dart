import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:firebase_rules_linter/lints/avoid_raw_rules.dart';
import 'package:firebase_rules_linter/lints/invalid_match_function.dart';
import 'package:firebase_rules_linter/lints/invalid_match_path.dart';
import 'package:firebase_rules_linter/lints/invalid_rules_function.dart';
import 'package:firebase_rules_linter/lints/no_set_literals.dart';
import 'package:firebase_rules_linter/lints/undeclared_enum_value.dart';

/// The firebase_rules_linter analyzer plugin
final plugin = FirebaseRulesLinterPlugin();

/// The firebase_rules_linter analyzer plugin
class FirebaseRulesLinterPlugin extends Plugin {
  @override
  String get name => 'firebase_rules_linter';

  @override
  void register(PluginRegistry registry) {
    registry
      ..registerWarningRule(AvoidRawRules())
      ..registerWarningRule(InvalidMatchFunction())
      ..registerFixForRule(InvalidMatchFunction.code, UseExpectedSignature.new)
      ..registerWarningRule(InvalidMatchPath())
      ..registerWarningRule(InvalidRulesFunction())
      ..registerWarningRule(NoSetLiterals())
      ..registerFixForRule(NoSetLiterals.code, UseListLiteral.new)
      ..registerWarningRule(UndeclaredEnumValue());
  }
}
