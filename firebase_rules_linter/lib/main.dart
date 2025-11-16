import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

/// The firebase_rules_linter analyzer plugin
final plugin = FirebaseRulesLinterPlugin();

/// The firebase_rules_linter analyzer plugin
class FirebaseRulesLinterPlugin extends Plugin {
  @override
  String get name => 'firebase_rules_linter';

  @override
  void register(PluginRegistry registry) {
    registry;
  }
}
