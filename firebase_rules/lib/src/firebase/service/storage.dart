import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules/src/firebase/service/base.dart';

/// The root of Storage
const storageRoot = '/b/{bucket}/o';

/// The resource variable contains the metadata of a file being uploaded or the
/// updated metadata for an existing file. This is related to the resource
/// variable, which contains the current file metadata at the requested path, as
/// opposed to the new metadata.
abstract class StorageResource extends FirebaseResource {
  /// A string containing the full name of the file, including the path to the
  /// file.
  RulesString get name;

  /// A string containing the Google Cloud Storage bucket this file is stored
  /// in.
  RulesString get bucket;

  /// A int containing the Google Cloud Storage object generation of the file.
  /// Used for object versioning.
  int get generation;

  /// A int containing the Google Cloud Storage object metageneration of the
  /// file. Used for object versioning.
  int get metageneration;

  /// An int containing the file size in bytes.
  int get size;

  /// A timestamp representing when the file was created.
  RulesTimestamp get timeCreated;

  /// A timestamp representing when the file was last updated.
  RulesTimestamp get updated;

  /// A string containing the MD5 hash of the file.
  RulesString get md5Hash;

  /// A string containing the crc32c hash of the file.
  RulesString get crc32c;

  /// A string containing the etag of the file.
  RulesString get etag;

  /// A string containing the content disposition of the file.
  RulesString get contentDisposition;

  /// A string containing the content encoding of the file.
  RulesString get contentEncoding;

  /// A string containing the content language of the file.
  RulesString get contentLanguage;

  /// The content type
  RulesString get contentType;

  /// A `Map<String, String>` containing additional developer provided metadata
  /// fields.
  RulesMap<RulesString, RulesString> get metadata;
}
