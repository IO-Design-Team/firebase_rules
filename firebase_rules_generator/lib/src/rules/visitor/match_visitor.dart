import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';
import 'package:firebase_rules/firebase_rules.dart';
import 'package:source_gen/source_gen.dart';

/// Visit Match elements
Stream<String> visitMatch(
  LibraryReader library,
  Resolver resolver,
  AstNode node,
) async* {
  final typeArguments = node.childEntities.whereType<TypeArgumentList>().single;
  final pathName = typeArguments.arguments[0].toSource();
  final pathElement = library.findType(pathName);

  final String path;
  if (pathElement == null) {
    if (pathName == 'FirestorePath') {
      path = FirestorePath.rawPath;
    } else if (pathName == 'StoragePath') {
      path = StoragePath.rawPath;
    } else {
      throw InvalidGenerationSourceError(
        'Invalid path type: $pathName',
        element: pathElement,
      );
    }
  } else {
    final ast = await resolver.astNodeFor(pathElement);
    final pathMethod = ast!.childEntities
        .whereType<MethodDeclaration>()
        .where((e) => e.name.toString() == 'path');
    final pathString = pathMethod.single.body.childEntities
        .whereType<StringLiteral>()
        .single
        .toSource();
    path = pathString
        .substring(1, pathString.length - 1)
        .replaceAllMapped(RegExp(r'\$([^\/]+)'), (m) => '{${m[1]}}');
  }

  print(path);

  yield '';
}
