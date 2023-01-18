import 'package:build/build.dart';
import 'package:firebase_rules_generator/src/rules_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Builds generators for `build_runner` to run
Builder rules(BuilderOptions options) => LibraryBuilder(
      RulesGenerator(),
      generatedExtension: '.rules',
      formatOutput: (input) => input,
    );
