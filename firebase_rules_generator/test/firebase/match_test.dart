import 'util.dart';

void main() {
  testFirebaseRulesBuilder('match/valid');
  testFirebaseRulesBuilder('match/invalid_1', expectThrows: true);
}
