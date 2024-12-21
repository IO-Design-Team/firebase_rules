import 'package:build/build.dart';
import 'package:firebase_rules_generator/src/database/generator.dart';
import 'package:firebase_rules_generator/src/common/formatter.dart';
import 'package:firebase_rules_generator/src/firebase/generator.dart';
import 'package:source_gen/source_gen.dart';

/// Run the [FirebaseRulesGenerator]
Builder firebaseRules(BuilderOptions options) => LibraryBuilder(
      FirebaseRulesGenerator(),
      generatedExtension: '.rules',
      formatOutput: (input, version) =>
          formatRules('FirebaseRulesGenerator', input),
    );

/// Run the [DatabaseRulesGenerator]
Builder databaseRules(BuilderOptions options) => LibraryBuilder(
      DatabaseRulesGenerator(),
      generatedExtension: '.rules.json',
      formatOutput: (input, version) =>
          formatRules('DatabaseRulesGenerator', input),
    );
