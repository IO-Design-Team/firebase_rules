import 'package:firebase_rules/database.dart';

@DatabaseRules()
final databaseRules = [
  Match(
    r'rules/users/$userId',
    read: (userId) => auth != null && auth?.uid == userId,
    write: (userId) => userId == 'user1'.rules,
    validate: (userId) => !data.exists(),
    indexOn: ['uid', 'email'],
    matches: (userId) => [
      Match(
        r'contracts/$contractId',
        read: (contractId) =>
            root
                .child('users'.rules)
                .child(userId)
                .child(contractId)
                /// The `val` type parameters will be stripped by the generator
                .val<int?>() !=
            null,
        write: (contractId) =>
            root.child('users'.rules).child(userId).child(contractId).val() !=
            null,
      ),
    ],
  ),
];
