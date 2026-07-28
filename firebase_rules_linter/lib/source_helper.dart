import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

/// Helpers for [DartType].
extension DartTypeExtension on DartType {
  /// Whether this type is an enum.
  bool get isEnum {
    final myType = this;
    return myType is InterfaceType && myType.element is EnumElement;
  }
}
