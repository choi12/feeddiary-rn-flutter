// 화분 모델 round-trip — snake→camel(max_exp/watering_count/love_count) (unit, Tier A).
import 'package:feeddiary/data/models/flowerpot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> flowerpotJson() => {
    'level': 2,
    'exp': 450,
    'max_exp': 1000,
    'watering_count': 3,
    'love_count': 1,
    'showBadge': true,
  };

  test('Flowerpot 가 snake_case 를 camelCase 로 매핑한다', () {
    final f = Flowerpot.fromJson(flowerpotJson());
    expect(f.level, 2);
    expect(f.exp, 450);
    expect(f.maxExp, 1000);
    expect(f.wateringCount, 3);
    expect(f.loveCount, 1);
    expect(f.showBadge, true);
  });

  test('Flowerpot round-trip 이 값을 보존한다', () {
    final original = Flowerpot.fromJson(flowerpotJson());
    final restored = Flowerpot.fromJson(original.toJson());
    expect(restored, original);
    expect(original.toJson()['max_exp'], 1000);
    expect(original.toJson()['watering_count'], 3);
  });
}
