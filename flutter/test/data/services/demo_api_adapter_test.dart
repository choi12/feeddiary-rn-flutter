// DemoApiAdapter — 닉네임 변경 후에도 본인 일기·댓글이 현재 닉네임으로 내려오는지(작성자 소유 판정 유지).
import 'package:feeddiary/data/repositories/community_repository.dart';
import 'package:feeddiary/data/repositories/diary_repository.dart';
import 'package:feeddiary/data/repositories/profile_repository.dart';
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('닉네임을 바꾸면 본인 시드·신규 일기와 신규 댓글이 새 닉네임으로 내려오고 타작성자는 그대로다', () async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: Duration.zero);
    final diaries = DiaryRepository(dio);
    final community = CommunityRepository(dio);

    final created = await diaries.createDiary(sticker: 'Star', text: '새 일기', date: DateTime(2026, 6));
    await community.createComment(diaryIdx: 1001, text: '내 댓글');
    await ProfileRepository(dio).updateProfile(nickname: '새이름', background: '', character: 'Chick');

    expect((await diaries.getDiary(diaryIdx: 1001)).nickname, '새이름');
    expect((await diaries.getDiary(diaryIdx: created)).nickname, '새이름');
    final comments = await community.getComments(diaryIdx: 1001);
    expect(comments.last.nickname, '새이름');
    expect(comments.first.nickname, isNot('새이름'));
    expect((await diaries.getDiary(diaryIdx: 1)).nickname, isNot('새이름'));
  });

  test('캐릭터·배경을 바꾸면 본인 시드·신규 일기와 신규 댓글의 아바타가 새 프로필로 내려오고 타작성자는 그대로다', () async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: Duration.zero);
    final diaries = DiaryRepository(dio);
    final community = CommunityRepository(dio);
    final seedAuthor = await diaries.getDiary(diaryIdx: 1);
    final seedComment = (await community.getComments(diaryIdx: 1001)).first;

    final created = await diaries.createDiary(sticker: 'Star', text: '새 일기', date: DateTime(2026, 6));
    await community.createComment(diaryIdx: 1001, text: '내 댓글');
    final user = await ProfileRepository(dio).updateProfile(nickname: '새싹이', background: '#ABCDEF', character: 'Bear');

    for (final idx in [1001, created]) {
      final diary = await diaries.getDiary(diaryIdx: idx);
      expect((diary.character, diary.background, diary.userImage), ('Bear', '#ABCDEF', user.image));
    }
    final comments = await community.getComments(diaryIdx: 1001);
    final mine = comments.last;
    expect((mine.character, mine.background, mine.userImage), ('Bear', '#ABCDEF', user.image));
    expect(comments.first, seedComment);
    expect(await diaries.getDiary(diaryIdx: 1), seedAuthor);
  });
}
