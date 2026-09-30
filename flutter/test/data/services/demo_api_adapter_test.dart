// DemoApiAdapter — 닉네임 변경 후에도 본인 일기·댓글이 현재 닉네임으로 내려오는지(작성자 소유 판정 유지) + 공유 목록의 본인 일기 노출 규칙 + 미션 시드·보상(원본 백엔드 값).
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/data/repositories/community_repository.dart';
import 'package:feeddiary/data/repositories/diary_repository.dart';
import 'package:feeddiary/data/repositories/mission_repository.dart';
import 'package:feeddiary/data/repositories/profile_repository.dart';
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/community_sort.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
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

  test('본인 일기는 시드든 신규든 공개면 공유 목록에 보이고, 비공개로 돌리면 빠진다(실서비스와 같은 규칙)', () async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: Duration.zero);
    final diaries = DiaryRepository(dio);
    final community = CommunityRepository(dio);
    Future<List<int>> communityIdxs() async {
      final idxs = <int>[];
      for (var skip = 0; ; skip = idxs.length) {
        final page = await community.getCommunityDiaries(skip: skip, sort: CommunitySort.latest);
        idxs.addAll(page.map((d) => d.idx));
        if (page.isEmpty) return idxs;
      }
    }

    // 시드 1002 는 처음부터 공개, 1001 은 비공개.
    expect((await diaries.getDiary(diaryIdx: 1002)).isVisible, isTrue);
    expect((await diaries.getDiary(diaryIdx: 1001)).isVisible, isFalse);
    expect(await communityIdxs(), allOf(contains(1002), isNot(contains(1001))));

    expect(await diaries.setVisibility(diaryIdx: 1001), isTrue);
    expect(await communityIdxs(), contains(1001));

    expect(await diaries.setVisibility(diaryIdx: 1002), isFalse);
    expect(await communityIdxs(), isNot(contains(1002)));
  });

  test('미션 시드 목표와 완료 보상이 원본 백엔드(MISSION_LIST·MISSION_REWARD)와 같다', () async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: Duration.zero);
    final missions = MissionRepository(dio);

    final seed = await missions.getMissions();
    final all = [...seed.completed, ...seed.inProgress];
    expect(
      {for (final m in all) m.type: m.maxCount},
      {MissionType.diary: 1, MissionType.visible: 1, MissionType.like: 5, MissionType.comment: 3},
    );
    final diary = seed.completed.single;
    expect((diary.type, diary.count, diary.isCompleted), (MissionType.diary, 1, true));

    final rewards = {
      for (final m in seed.inProgress) m.type: (await missions.completeMission(missionIdx: m.idx, type: m.type)).reward,
    };
    expect(rewards[MissionType.visible], const RewardItem(count: 3, item: PlantAction.love));
    expect(rewards[MissionType.like], const RewardItem(count: 1, item: PlantAction.love));
    expect(rewards[MissionType.comment], const RewardItem(count: 2, item: PlantAction.watering));
  });
}
