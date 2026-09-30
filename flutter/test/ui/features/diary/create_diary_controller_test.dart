// CreateDiaryController — 수정 제출 시 사진 삭제 여부가 image_text 로 전달되는지 (ProviderContainer + http_mock_adapter). RN useWriteDiary.
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/features/diary/create_diary_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  const imageUrl = 'https://example.com/diary.jpg';
  final initial = MyDiary(
    idx: 7,
    userIdx: 1,
    nickname: '새싹이',
    sticker: 'Star',
    text: '사진 있는 일기',
    image: imageUrl,
    createdAt: DateTime(2026, 6),
    isVisible: false,
    likeCount: 0,
    commentCount: 0,
  );

  /// 수정 제출 후 PUT /diary 멀티파트의 image_text 값을 돌려준다.
  Future<String?> submittedImageText({required bool imageDeleted}) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    String? imageText;
    dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final fields = (options.data as FormData).fields;
          imageText = fields.firstWhere((field) => field.key == 'image_text').value;
          handler.next(options);
        },
      ),
    );
    DioAdapter(dio: dio).onPut(
      '/diary',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'diaryIdx': 7},
      }),
      data: Matchers.any,
    );
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    container.listen(createDiaryControllerProvider(initial), (_, _) {});

    await container.read(createDiaryControllerProvider(initial).notifier).submit(imageDeleted: imageDeleted);
    return imageText;
  }

  test('사진을 지우고 수정하면 image_text 를 빈 문자열로 보낸다', () async {
    expect(await submittedImageText(imageDeleted: true), '');
  });

  test('사진을 그대로 두고 수정하면 기존 이미지를 image_text 로 보낸다', () async {
    expect(await submittedImageText(imageDeleted: false), imageUrl);
  });
}
