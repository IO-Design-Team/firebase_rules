// TODO: Inject database base path into these

/// Check if a document exists.
bool exists(String path) => throw UnimplementedError();

/// Check if a document exists, assuming the current request succeeds.
/// Equivalent to getAfter(path) != null.
bool existsAfter(String path) => throw UnimplementedError();

/// Get the contents of a firestore document.
T get<T>(String path) => throw UnimplementedError();

/// Get the projected contents of a document. The document is returned as if the
/// current request had succeeded. Useful for validating documents that are part
/// of a batched write or transaction.
T getAfter<T>(String path) => throw UnimplementedError();