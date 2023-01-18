/// String indent extension
extension IndentExtension on String {
  /// Returns the string with the given [indent] prepended to each line
  String indent(int indent) => ' ' * indent + this;
}
