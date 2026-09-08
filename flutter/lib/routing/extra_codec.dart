// GoRouter extra 코덱 — 웹 히스토리에 저장/복원되는 extra 를 타입 태그 + JSON 으로 왕복시킨다.
import 'dart:convert';

import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';

const String _diaryTag = 'MyDiary';
const String _newUserTag = 'NewUserInfo';

/// 웹에서 GoRouter 는 `extra` 를 브라우저 히스토리 state 에 JSON 으로 넣는다. 코덱이 없으면
/// 뒤로/앞으로 가기로 복원된 extra 가 원래 타입이 아니라 `Map`(직렬화 불가한 타입은 아예 null)이라
/// 라우트 builder 의 캐스팅이 깨진다. `[태그, 데이터]` 로 감싸 복원 시 원래 타입으로 되돌린다.
class ExtraCodec extends Codec<Object?, Object?> {
  const ExtraCodec();

  @override
  Converter<Object?, Object?> get encoder => const _ExtraEncoder();

  @override
  Converter<Object?, Object?> get decoder => const _ExtraDecoder();
}

class _ExtraEncoder extends Converter<Object?, Object?> {
  const _ExtraEncoder();

  @override
  Object? convert(Object? input) => switch (input) {
    final MyDiary diary => [_diaryTag, diary.toJson()],
    final NewUserInfo info => [
      _newUserTag,
      {'uid': info.uid, 'email': info.email, 'type': info.type.name},
    ],
    // 나머지(댓글 화면의 작성자 닉네임 등)는 JSON 원시값이라 그대로 저장한다.
    _ => input,
  };
}

class _ExtraDecoder extends Converter<Object?, Object?> {
  const _ExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input is! List || input.length != 2) return input;
    final [tag, data] = input;
    return switch (tag) {
      _diaryTag => MyDiary.fromJson(Map<String, dynamic>.from(data! as Map)),
      _newUserTag => _newUserInfo(Map<String, dynamic>.from(data! as Map)),
      _ => input,
    };
  }

  NewUserInfo _newUserInfo(Map<String, dynamic> json) => NewUserInfo(
    uid: json['uid'] as String,
    email: json['email'] as String,
    type: SignInType.values.byName(json['type'] as String),
  );
}
