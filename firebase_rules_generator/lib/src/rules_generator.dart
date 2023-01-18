import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:source_gen/source_gen.dart';

/// Generate Firebase rules from a list of [Match] objects
class RulesGenerator extends GeneratorForAnnotation<FirebaseRules> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    assert(element is List<Match>);
    return 'This is a test';
  }
}
