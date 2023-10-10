import 'util.dart';

void main() {
  testDatabaseRulesBuilder('match/valid');
  testDatabaseRulesBuilder('match/invalid_1', expectThrows: true);
}
