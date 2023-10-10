import 'util.dart';

void main() {
  testDatabaseRulesBuilder('match/valid');
  testDatabaseRulesBuilder('match/invalid_1', expectThrows: true);
  testDatabaseRulesBuilder('match/invalid_2', expectThrows: true);
  testDatabaseRulesBuilder('match/invalid_3', expectThrows: true);
  testDatabaseRulesBuilder('match/invalid_4', expectThrows: true);
  testDatabaseRulesBuilder('match/invalid_5', expectThrows: true);
  testDatabaseRulesBuilder('match/invalid_6', expectThrows: true);
}
