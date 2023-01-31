import 'package:firebase_rules/database.dart';
import 'package:firebase_rules/firebase.dart';

/// Create rules for Firestore
@FirebaseRules(service: Service.firestore)
final firestoreRules = [];

/// Create rules for Storage
@FirebaseRules(service: Service.storage)
final storageRules = [];

/// Create rules for Realtime Database
@DatabaseRules()
final databaseRules = [];
