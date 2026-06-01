// AppVersion freezed 모델 round-trip + snake_case 매핑 검증 (unit / Tier A).
import 'package:feeddiary/data/models/app_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppVersion', () {
    const json = {'app_version_android': '1.2.3', 'app_version_ios': '1.2.4'};

    test('fromJson 이 snake_case 키를 camelCase 필드로 매핑한다', () {
      final version = AppVersion.fromJson(json);
      expect(version.android, '1.2.3');
      expect(version.ios, '1.2.4');
    });

    test('toJson round-trip 이 원본 키를 보존한다', () {
      final version = AppVersion.fromJson(json);
      expect(version.toJson(), json);
    });
  });
}
