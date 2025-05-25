import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_generator/src/common/rules_context.dart';
import 'package:firebase_rules_generator/src/common/generator.dart';
import 'package:firebase_rules_generator/src/firebase/revived_firebase_rules.dart';
import 'package:firebase_rules_generator/src/firebase/sanitizer.dart';
import 'package:firebase_rules_generator/src/firebase/util.dart';
import 'package:firebase_rules_generator/src/firebase/visitor/match_visitor.dart';
import 'package:source_gen/source_gen.dart';

/// Generate Firebase rules from a list of [Match] objects
class FirebaseRulesGenerator extends GeneratorForAnnotation<FirebaseRules>
    with RulesGenerator {
  @override
  Future<String> generateForAnnotatedElement(
    /// TODO: Fix with analyzer 8
    /// ignore: deprecated_member_use
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    checkType(element);

    final revived = reviveAnnotation(annotation);

    final buffer = StringBuffer();
    buffer.writeln('rules_version = \'${revived.rulesVersion}\';');
    buffer.writeln('service ${revived.service} {');

    // Generate functions
    final resolver = buildStep.resolver;
    final context = RulesContext.root(resolver, functions: revived.functions);
    final ast = await resolver.astNodeFor(element);
    final matches = ast!.childEntities.whereType<ListLiteral>().single.elements;

    for (final match in matches) {
      await for (final line in visitMatch(context, match)) {
        buffer.writeln(line);
      }
    }

    buffer.writeln('}');
    return sanitizeRules(revived, buffer.toString());
  }

  /// Reconstruct the [FirebaseRules] object from the annotation
  RevivedFirebaseRules reviveAnnotation(ConstantReader annotation) {
    return RevivedFirebaseRules(
      rulesVersion: annotation.read('rulesVersion').stringValue,
      service: readEnum(annotation.read('service'), Service.values)!,
      functions: annotation
          .read('functions')
          .listValue

          /// TODO: Fix with analyzer 8
          /// ignore: deprecated_member_use
          .map((e) => e.toFunctionValue()!),
      enums: annotation.read('enums').listValue.map(reviveEnumMap),
    );
  }

  /// Revive a `Map<Enum, String>` to a `Map<String, String>` from a [DartObject]
  Map<String, String> reviveEnumMap(DartObject value) {
    return value.toMapValue()!.cast<DartObject, DartObject>().map((k, v) {
      final enumType = k.type;
      final enumValue = k.getField('_name')!.toStringValue();
      return MapEntry('$enumType.$enumValue', v.toStringValue()!);
    });
  }
}
