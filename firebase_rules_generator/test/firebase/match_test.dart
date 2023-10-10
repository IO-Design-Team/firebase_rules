import 'util.dart';

void main() {
  testFirebaseRulesBuilder('match/valid');
  testFirebaseRulesBuilder('match/invalid_1', expectThrows: true);
  testFirebaseRulesBuilder('match/invalid_2', expectThrows: true);
  testFirebaseRulesBuilder('match/invalid_3', expectThrows: true);
  testFirebaseRulesBuilder('match/invalid_4', expectThrows: true);
}
