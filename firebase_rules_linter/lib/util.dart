import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

/// Type checker for `FirebaseRules`
const firebaseRulesTypeChecker = TypeChecker.typeNamed(
  TypeNamed('FirebaseRules'),
  inPackage: 'firebase_rules',
);

/// Type checker for `FirebaseMatch`
const firebaseMatchChecker = TypeChecker.typeNamed(
  TypeNamed('FirebaseMatch'),
  inPackage: 'firebase_rules',
);

/// Type checker for `DatabaseMatch`
const databaseMatchChecker = TypeChecker.typeNamed(
  TypeNamed('DatabaseMatch'),
  inPackage: 'firebase_rules',
);

/// Resolve a match path
String? resolveMatchPath({required NodeList<Expression> arguments}) {
  final pathArgument = arguments.first;
  if (pathArgument is SimpleStringLiteral) {
    return pathArgument.value;
  } else if (pathArgument is SimpleIdentifier) {
    final pathName = pathArgument.name;
    if (pathName == 'firestoreRoot') {
      return '/databases/{database}/documents';
    } else if (pathName == 'storageRoot') {
      return '/b/{bucket}/o';
    }
  }

  // The path is invalid
  return null;
}

/// Get the first `FirebaseRules` annotation in a file
Future<DartObject?> getFirebaseRulesAnnotation(
  CustomLintResolver resolver,
) async {
  final resolved = await resolver.getResolvedUnitResult();

  for (final element in resolved.libraryElement.topLevelVariables) {
    final annotation = firebaseRulesTypeChecker.firstAnnotationOfExact(element);
    if (annotation != null) return annotation;
  }
  return null;
}

/// Create a Type class whose toString() method returns the name
///
/// Workaround for TypeChecker.typeNamed() not accepting a String.
@immutable
class TypeNamed implements Type {
  /// The name of the type
  final String name;

  /// Constructor
  const TypeNamed(this.name);

  @override
  String toString() => name;
}
