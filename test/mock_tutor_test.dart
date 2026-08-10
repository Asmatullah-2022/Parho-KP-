import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/features/ai_tutor/mock_tutor.dart';

void main() {
  test('mock tutor gives a fractions explanation for a fractions question', () {
    final reply = MockTutor.reply('I do not understand fractions', 'en');
    expect(reply.toLowerCase(), contains('1/4'));
  });

  test('mock tutor answers in the requested language', () {
    final urdu = MockTutor.reply('fractions', 'ur');
    expect(urdu, contains('روٹی'));
    final pashto = MockTutor.reply('fractions', 'ps');
    expect(pashto, contains('ډوډۍ'));
  });

  test('mock tutor gives an encouraging default reply', () {
    final reply = MockTutor.reply('hello there', 'en');
    expect(reply, isNotEmpty);
  });
}
