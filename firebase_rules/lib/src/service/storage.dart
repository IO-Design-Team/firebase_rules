import 'package:firebase_rules/src/namespace/model/timestamp.dart';
import 'package:firebase_rules/src/rules_type.dart';

import 'package:firebase_rules/firebase_rules.dart';

/// Base firestore path
class StoragePath extends Path {
  /// The current database
  String get bucket => throw UnimplementedError();

  @override
  String get path => '/b/$bucket/o';
}


/// The resource variable contains the metadata of a file being uploaded or the
/// updated metadata for an existing file. This is related to the resource
/// variable, which contains the current file metadata at the requested path, as
/// opposed to the new metadata.
abstract class StorageResource extends RulesType {
  /// A string containing the full name of the file, including the path to the
  /// file.
  String get name;

  /// A string containing the Google Cloud Storage bucket this file is stored
  /// in.
  String get bucket;

  /// A int containing the Google Cloud Storage object generation of the file.
  /// Used for object versioning.
  int get generation;

  /// A int containing the Google Cloud Storage object metageneration of the
  /// file. Used for object versioning.
  int get metageneration;

  /// An int containing the file size in bytes.
  int get size;

  /// A timestamp representing when the file was created.
  Timestamp get timeCreated;

  /// A timestamp representing when the file was last updated.
  Timestamp get updated;

  /// A string containing the MD5 hash of the file.
  String get md5Hash;

  /// A string containing the crc32c hash of the file.
  String get crc32c;

  /// A string containing the etag of the file.
  String get etag;

  /// A string containing the content disposition of the file.
  String get contentDisposition;

  /// A string containing the content encoding of the file.
  String get contentEncoding;

  /// A string containing the content language of the file.
  String get contentLanguage;

  /// The content type
  String get contentType;

  /// A Map<String, String> containing additional developer provided metadata
  /// fields.
  Map<String, String> get metadata;
}
