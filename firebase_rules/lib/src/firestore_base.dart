import 'package:firebase_rules/firestore.dart';

class FirestorePath extends Path {
  String get database => throw UnimplementedError();

  @override
  String get path => 'databases/$database/documents';
}

