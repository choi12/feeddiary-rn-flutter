// Comment 모델 — snake→camel·created_time DateTime round-trip (unit test).
import 'package:feeddiary/data/models/comment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson 이 snake_case 를 camelCase 로 매핑한다', () {
    final comment = Comment.fromJson({
      'idx': 7,
      'nickname': '햇살이',
      'background': 'bg',
      'character': 'Bear',
      'text': '좋은 글이에요.',
      'created_time': '2026-06-01T09:30:00.000Z',
      'user_image': 'http://img',
    });

    expect(comment.idx, 7);
    expect(comment.nickname, '햇살이');
    expect(comment.userImage, 'http://img');
    expect(comment.createdAt, DateTime.parse('2026-06-01T09:30:00.000Z'));
  });

  test('toJson 이 camelCase 를 snake_case 로 되돌린다', () {
    final comment = Comment(
      idx: 7,
      nickname: '햇살이',
      background: 'bg',
      character: 'Bear',
      text: '본문',
      createdAt: DateTime.parse('2026-06-01T09:30:00.000Z'),
      userImage: 'http://img',
    );

    final json = comment.toJson();
    expect(json['created_time'], '2026-06-01T09:30:00.000Z');
    expect(json['user_image'], 'http://img');
  });
}
