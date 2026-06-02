// 미션 모델 round-trip — is_completed 0/1↔bool·max_count→maxCount + MissionsResult/RewardItem/CompleteMissionResult (unit, Tier A).
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> missionJson({int isCompleted = 0}) => {
    'idx': 1,
    'type': 'diary',
    'count': 1,
    'max_count': 3,
    'is_completed': isCompleted,
  };

  test('Mission 이 is_completed 0/1 을 bool 로, max_count 를 maxCount 로 매핑한다', () {
    final m = Mission.fromJson(missionJson(isCompleted: 1));
    expect(m.type, MissionType.diary);
    expect(m.maxCount, 3);
    expect(m.isCompleted, true);
    expect(m.isAchieved, false); // count 1 < maxCount 3
  });

  test('Mission isAchieved 는 count==maxCount 에서 true', () {
    final m = Mission.fromJson({'idx': 3, 'type': 'visible', 'count': 1, 'max_count': 1, 'is_completed': 0});
    expect(m.isAchieved, true);
    expect(m.type, MissionType.visible);
  });

  test('Mission round-trip 이 is_completed 0/1 직렬화를 보존한다', () {
    final original = Mission.fromJson(missionJson(isCompleted: 1));
    final restored = Mission.fromJson(original.toJson());
    expect(restored, original);
    expect(original.toJson()['is_completed'], 1);
  });

  test('MissionsResult 가 진행중/완료를 분류한다', () {
    final result = MissionsResult.fromJson({
      'completed': [missionJson(isCompleted: 1)],
      'inProgress': [missionJson()],
    });
    expect(result.completed.length, 1);
    expect(result.inProgress.length, 1);
    expect(result.completed.first.isCompleted, true);
  });

  test('RewardItem / CompleteMissionResult 매핑(item enum)', () {
    final reward = RewardItem.fromJson({'count': 2, 'item': 'watering'});
    expect(reward.count, 2);
    expect(reward.item, PlantAction.watering);

    final complete = CompleteMissionResult.fromJson({
      'missions': {'completed': <dynamic>[], 'inProgress': <dynamic>[]},
      'reward': {'count': 1, 'item': 'love'},
    });
    expect(complete.reward.item, PlantAction.love);
    expect(complete.missions.inProgress, isEmpty);
  });
}
