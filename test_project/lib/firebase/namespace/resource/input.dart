// This is a test
// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test1(FirestoreResource<ResourceTest> resource) {
  final a = resource.firestoreResourceName ==
      rules.path('/collection/${resource.id}'.rules(), database: 'default');
  final b = resource.data.asdf;
  return true;
}

bool test2(StorageResource resource) {
  final a = resource.name;
  final b = resource.bucket;
  final c = resource.generation;
  final d = resource.metageneration;
  final e = resource.size;
  final f = resource.timeCreated;
  final g = resource.updated;
  final h = resource.md5Hash;
  final i = resource.crc32c;
  final j = resource.etag;
  final k = resource.contentDisposition;
  final l = resource.contentEncoding;
  final m = resource.contentLanguage;
  final n = resource.contentType;
  final o = resource.metadata;
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test1, test2],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];

abstract class ResourceTest {
  int get asdf;
}
