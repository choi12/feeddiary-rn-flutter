// ExtraCodec — 웹 히스토리(JSON) 왕복 후에도 GoRouter extra 가 원래 타입으로 복원되는지 검증 (Tier A).
import 'dart:convert';

import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/extra_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const codec = ExtraCodec();

  /// 브라우저 히스토리 state 는 JSON 으로 직렬화되므로 인코딩 결과를 JSON 왕복시켜 복원한다.
  Object? roundTrip(Object? extra) => codec.decode(jsonDecode(jsonEncode(codec.encode(extra))));

  test('MyDiary extra 를 원래 타입으로 복원한다', () {
    final diary = MyDiary(
      idx: 7,
      userIdx: 3,
      nickname: '레모니',
      sticker: 'happy',
      text: '오늘의 일기',
      image: null,
      createdAt: DateTime.utc(2026, 6, 4, 9, 30),
      updatedAt: DateTime.utc(2026, 6, 5),
      isVisible: true,
      likeCount: 2,
      commentCount: 1,
    );

    expect(roundTrip(diary), diary);
  });

  test('NewUserInfo extra 를 원래 타입으로 복원한다', () {
    final restored = roundTrip(const NewUserInfo(uid: 'uid-1', email: 'a@b.com', type: SignInType.apple));

    expect(restored, isA<NewUserInfo>());
    final info = restored! as NewUserInfo;
    expect(info.uid, 'uid-1');
    expect(info.email, 'a@b.com');
    expect(info.type, SignInType.apple);
  });

  test('원시값/null extra 는 그대로 통과시킨다', () {
    expect(roundTrip('레모니'), '레모니');
    expect(roundTrip(null), isNull);
  });
}
