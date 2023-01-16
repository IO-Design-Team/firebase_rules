import 'dart:core' as core;

/// List type. Items are not necessarily homogenous.
abstract class List<T> {
  List._();

  /// Index operator, get value index i
  T operator [](core.int i);

  /// Range operator, get sublist from index i to j
  List<T> range(core.int i, core.int j);
}

/// Access to [List] methods
extension FirebaseListConversion<T> on core.List<T> {
  /// Access to [List] methods
  List<T> get f => throw core.UnimplementedError();
}
