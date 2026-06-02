// FlowerpotStats 파생 — canWater/canLove/isMaxLevel·null 디폴트·expProgress (unit, Tier A). RN useFlowerpotStats.
import 'package:feeddiary/data/models/flowerpot.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Flowerpot pot({int level = 1, int exp = 0, int wateringCount = 0, int loveCount = 0}) => Flowerpot(
    level: level,
    exp: exp,
    maxExp: 1000,
    wateringCount: wateringCount,
    loveCount: loveCount,
    showBadge: false,
  );

  test('null 화분은 기본값(레벨1·물/사랑 불가)', () {
    final stats = FlowerpotStats.from(null);
    expect(stats.level, 1);
    expect(stats.maxExp, 1000);
    expect(stats.canWater, false); // 화분 없음
    expect(stats.canLove, false);
    expect(stats.isMaxLevel, false);
  });

  test('레벨 2 + 충전 있으면 물/사랑 가능(충전별 독립)', () {
    final stats = FlowerpotStats.from(pot(level: 2, wateringCount: 1));
    expect(stats.canWater, true);
    expect(stats.canLove, false); // loveCount 0
  });

  test('최대 레벨(3)이면 충전이 있어도 물/사랑 불가·isMaxLevel', () {
    final stats = FlowerpotStats.from(pot(level: 3, wateringCount: 5, loveCount: 5));
    expect(stats.isMaxLevel, true);
    expect(stats.canWater, false);
    expect(stats.canLove, false);
  });

  test('expProgress 는 exp/maxExp(0~1 clamp)', () {
    expect(FlowerpotStats.from(pot(exp: 250)).expProgress, 0.25);
    expect(FlowerpotStats.from(pot(exp: 2000)).expProgress, 1.0);
  });
}
