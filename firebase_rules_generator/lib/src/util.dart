import 'package:analyzer/dart/constant/value.dart';
import 'package:firebase_rules_generator/src/rules/rules_context.dart';
import 'package:source_gen/source_gen.dart';

/// String indent extension
extension IndentExtension on String {
  /// Returns the string with the given [indent] prepended to each line
  String indent(int indent) => ' ' * indent + this;
}

/// String substitution extension
extension SubstitutionExtension on String {
  /// Perform substitution with contextual data
  String substitute(RulesContext context) {
    var substituted = this;
    for (final path in context.paths) {
      substituted = substituted._substitute(path);
    }
    return substituted._substitute('rules');
  }

  String _substitute(String match) {
    return replaceAll(RegExp(r'\.' + match + r'\.'), '')
        .replaceAll(RegExp(r'\.' + match), '');
  }
}

/// Read an enum from a [ConstantReader]
///
/// Copied from `package:json_serializable/src/utils.dart`
T? readEnum<T extends Enum>(ConstantReader reader, List<T> values) =>
    reader.isNull
        ? null
        : enumValueForDartObject<T>(
            reader.objectValue,
            values,
            (f) => f.name,
          );

/// Read an enum from a [DartObject]
///
/// Copied from `package:json_serializable/src/utils.dart`
T enumValueForDartObject<T>(
  DartObject source,
  List<T> items,
  String Function(T) name,
) =>
    items[source.getField('index')!.toIntValue()!];
