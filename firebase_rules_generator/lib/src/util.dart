import 'package:analyzer/dart/constant/value.dart';
import 'package:source_gen/source_gen.dart';

/// String indent extension
extension IndentExtension on String {
  /// Returns the string with the given [indent] prepended to each line
  String indent(int indent) => ' ' * indent + this;
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
