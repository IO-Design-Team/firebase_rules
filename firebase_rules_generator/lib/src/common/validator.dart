import 'package:analyzer/dart/ast/ast.dart';
import 'package:source_gen/source_gen.dart';

/// Validate the given functions parameters
void validateFunctionParameters({
  required String path,
  required String wildcardMatcher,
  required FunctionExpression function,
  required String Function(String wildcard) createExpectedSignature,
}) {
  final String expectedWildcardParameterName;
  final pathWildcards = RegExp(wildcardMatcher).allMatches(path);
  if (pathWildcards.length > 1) {
    throw InvalidGenerationSourceError(
      'Path cannot contain more than one wildcard: $path',
    );
  } else if (pathWildcards.length == 1) {
    expectedWildcardParameterName = pathWildcards.single[1]!;
  } else {
    expectedWildcardParameterName = '_';
  }

  final expectedSignature =
      createExpectedSignature(expectedWildcardParameterName);
  final actualSignature = function.parameters.toString();
  if (expectedSignature != actualSignature) {
    throw InvalidGenerationSourceError(
      'Invalid signature: $actualSignature\nExpected: $expectedSignature',
    );
  }
}
