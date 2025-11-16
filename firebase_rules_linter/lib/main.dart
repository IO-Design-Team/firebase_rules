import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:firebase_rules_linter/lints/avoid_raw_rules.dart';
import 'package:firebase_rules_linter/lints/invalid_match_function.dart';

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
      ..registerFixForRule(InvalidMatchFunction.code, UseExpectedSignature.new);
  }
}
