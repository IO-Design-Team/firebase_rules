import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Builds generators for `build_runner` to run
Builder rules(BuilderOptions options) => LibraryBuilder(RulesGenerator(),
    generatedExtension: '.openapi_generator');
