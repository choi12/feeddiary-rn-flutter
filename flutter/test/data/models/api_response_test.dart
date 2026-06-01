// ApiResponse<T> 제네릭 envelope round-trip 검증 (unit / Tier A).
import 'package:feeddiary/data/models/api_response.dart';
import 'package:feeddiary/data/models/app_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiResponse', () {
    test('primitive 페이로드를 fromJson/toJson 한다', () {
      final json = {'status': 'success', 'message': null, 'resData': 'hello'};
      final res = ApiResponse<String>.fromJson(json, (data) => data! as String);
      expect(res.status, 'success');
      expect(res.resData, 'hello');
      expect(res.toJson((value) => value), json);
    });

    test('중첩 모델 페이로드를 디코딩한다', () {
      final json = {
        'status': 'success',
        'resData': {'app_version_android': '1.0.0', 'app_version_ios': '1.0.1'},
      };
      final res = ApiResponse<AppVersion>.fromJson(json, (data) => AppVersion.fromJson(data! as Map<String, dynamic>));
      expect(res.status, 'success');
      expect(res.resData?.android, '1.0.0');
    });
  });
}
