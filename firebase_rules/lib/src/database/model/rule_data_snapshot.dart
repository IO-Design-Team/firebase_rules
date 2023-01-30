/// A Rule Data Snapshot
abstract class RuleDataSnapshot {
  /// Gets the primitive value (string, number, boolean, or null) from this
  /// RuleDataSnapshot.
  dynamic val();

  /// Gets a RuleDataSnapshot for the location at the specified relative path.
  RuleDataSnapshot child(String path);

  /// Gets a RuleDataSnapshot for the parent location.
  RuleDataSnapshot parent();

  /// Returns true if the specified child exists.
  bool hasChild(String path);

  /// Checks for the existence of children.
  bool hasChildren([List<String> keys]);

  /// Returns true if this RuleDataSnapshot contains any data.
  bool exists();

  /// Gets the priority of the data in a RuleDataSnapshot.
  dynamic getPriority();

  /// Returns true if this RuleDataSnapshot contains a numeric value.
  bool isNumber();

  /// Returns true if this RuleDataSnapshot contains a string value.
  bool isString();

  /// Returns true if this RuleDataSnapshot contains a boolean value.
  bool isBoolean();
}
