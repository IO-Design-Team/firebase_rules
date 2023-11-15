import 'package:analyzer/dart/ast/ast.dart';
import 'package:source_gen/source_gen.dart';

/// Validate the given functions parameters
void validateFunctionParameters({
  required String path,
  required String wildcardMatcher,
  required FunctionExpression function,
  required String Function(String wildcard) createExpectedSignature,
}) {
  final String expectedWildcard;
  final wildcards = RegExp(wildcardMatcher).allMatches(path);
  if (wildcards.length > 1) {
    throw InvalidGenerationSourceError(
      'Path cannot contain more than one wildcard: $path',
    );
  } else if (wildcards.length == 1) {
    expectedWildcard = wildcards.single[1]!;
  } else {
    expectedWildcard = '_';
  }

  final expectedSignature = createExpectedSignature(expectedWildcard);
  final actualSignature = function.parameters.toString();
  if (expectedSignature != actualSignature) {
    throw InvalidGenerationSourceError(
      'Invalid signature: $actualSignature\nExpected: $expectedSignature',
    );
  }
}
