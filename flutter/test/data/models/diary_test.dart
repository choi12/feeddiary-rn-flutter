// 일기 모델 round-trip — snake→camel·is_visible(0/1↔bool)·DateTime 매핑 (unit, Tier A).
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/data/models/diary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> myDiaryJson() => {
    'idx': 1001,
    'user_idx': 1,
    'nickname': '새싹이',
    'sticker': 'Coffee',
    'text': '오늘의 일기',
    'image': '',
    'created_time': '2026-06-01T09:00:00.000Z',
    'updated_time': null,
    'is_visible': 1,
    'like_count': 3,
    'commentCount': 2,
  };

  test('MyDiary 가 snake_case 를 camelCase 로 매핑하고 is_visible 를 bool 로 변환한다', () {
    final diary = MyDiary.fromJson(myDiaryJson());
    expect(diary.userIdx, 1);
    expect(diary.isVisible, true);
    expect(diary.likeCount, 3);
    expect(diary.commentCount, 2);
    expect(diary.createdAt, DateTime.utc(2026, 6, 1, 9));
  });

  test('MyDiary round-trip 이 값을 보존한다(is_visible 0/1 직렬화 포함)', () {
    final original = MyDiary.fromJson(myDiaryJson());
    final restored = MyDiary.fromJson(original.toJson());
    expect(restored, original);
    expect(original.toJson()['is_visible'], 1);
  });

  test('DailyDiary 가 경량 필드만 매핑한다', () {
    final daily = DailyDiary.fromJson({
      'idx': 5,
      'sticker': 'Star',
      'text': '간단 기록',
      'created_time': '2026-05-20T00:00:00.000Z',
      'is_visible': 0,
    });
    expect(daily.idx, 5);
    expect(daily.isVisible, false);
  });

  test('CommunityDiary 가 작성자 프로필·좋아요를 포함하고 toMyDiary 로 축소된다', () {
    final json = myDiaryJson()..addAll({'user_image': 'img', 'background': 'bg', 'character': 'Chick', 'isLike': true});
    final community = CommunityDiary.fromJson(json);
    expect(community.userImage, 'img');
    expect(community.character, 'Chick');
    expect(community.isLike, true);
    expect(community.toMyDiary().idx, community.idx);
    expect(community.toMyDiary().likeCount, community.likeCount);
  });

  test('CreateDiaryResult / LikeResult 매핑', () {
    expect(CreateDiaryResult.fromJson({'diaryIdx': 42}).diaryIdx, 42);
    final like = LikeResult.fromJson({'like_count': 7, 'isLike': false});
    expect(like.likeCount, 7);
    expect(like.isLike, false);
  });
}
