// AppException 계층 — displayMessage 조합 + withOperation 타입 보존 (unit / Tier A).
import 'package:feeddiary/config/error_messages.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException', () {
    test('operation 없으면 displayMessage 는 기본 메시지', () {
      const e = NetworkException();
      expect(e.displayMessage, ErrorMessages.network);
    });

    test('withOperation 은 라벨을 붙이고 타입을 보존한다', () {
      final e = const UnauthorizedException().withOperation('로그인');
      expect(e, isA<UnauthorizedException>());
      expect(e.displayMessage, '[로그인] ${ErrorMessages.unauthorized}');
      expect(e.operation, '로그인');
    });

    test('ApiException 은 statusCode 와 서버 메시지를 보존한다', () {
      final e = const ApiException(statusCode: 500, message: '서버 터짐').withOperation('일기 작성');
      expect(e, isA<ApiException>());
      expect(e.statusCode, 500);
      expect(e.displayMessage, '[일기 작성] 서버 터짐');
    });
  });
}
