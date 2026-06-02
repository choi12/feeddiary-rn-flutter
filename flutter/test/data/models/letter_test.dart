// Letter 모델 — snake→camel·created_time DateTime round-trip·미인식 키 무시 (unit test).
import 'package:feeddiary/data/models/letter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson 이 snake_case 를 camelCase 로 매핑한다', () {
    final letter = Letter.fromJson({
      'idx': 7,
      'text': '오늘의 나에게',
      'created_time': '2026-06-01T09:30:00.000Z',
      'deleted_time': null,
    });

    expect(letter.idx, 7);
    expect(letter.text, '오늘의 나에게');
    expect(letter.createdAt, DateTime.parse('2026-06-01T09:30:00.000Z'));
  });

  test('toJson 이 createdAt 을 created_time 으로 되돌린다', () {
    final letter = Letter(idx: 7, text: '본문', createdAt: DateTime.parse('2026-06-01T09:30:00.000Z'));

    final json = letter.toJson();
    expect(json['created_time'], '2026-06-01T09:30:00.000Z');
  });

  test('deleted_time 등 미인식 키는 무시한다(RN 과 동일)', () {
    final letter = Letter.fromJson({
      'idx': 1,
      'text': 'x',
      'created_time': '2026-06-01T00:00:00.000Z',
      'deleted_time': '2026-06-02T00:00:00.000Z',
    });

    expect(letter.idx, 1);
    expect(letter.text, 'x');
  });
}
