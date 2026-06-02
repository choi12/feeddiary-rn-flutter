// User freezed 모델 round-trip + snake 매핑 + SignInType enum + created_time 파싱 (unit / Tier A).
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    final json = {
      'idx': 7,
      'account': 'me@example.com',
      'user_id': 'uid-123',
      'nickname': '새싹이',
      'image': 'https://img/x.png',
      'background': 'bg',
      'character': 'Chick',
      'type': 'google',
      'created_time': '2026-01-02T03:04:05.000Z',
      'token': 'tok',
      'fcm_token': 'fcm',
    };

    test('fromJson 이 snake_case 키를 camelCase 필드로 매핑한다', () {
      final user = User.fromJson(json);
      expect(user.idx, 7);
      expect(user.userId, 'uid-123');
      expect(user.type, SignInType.google);
      expect(user.createdAt, DateTime.utc(2026, 1, 2, 3, 4, 5));
      expect(user.fcmToken, 'fcm');
    });

    test('toJson round-trip 이 원본 snake_case 키를 보존한다', () {
      final user = User.fromJson(json);
      expect(user.toJson(), json);
    });

    test('fcm_token 은 선택적(없으면 null)', () {
      final without = Map<String, dynamic>.from(json)..remove('fcm_token');
      expect(User.fromJson(without).fcmToken, isNull);
    });

    test('apple 타입도 매핑된다', () {
      final apple = Map<String, dynamic>.from(json)..['type'] = 'apple';
      expect(User.fromJson(apple).type, SignInType.apple);
    });
  });
}
