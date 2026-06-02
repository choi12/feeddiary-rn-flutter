// 일기 작성/수정 폼 컨트롤러 — 스티커·본문·날짜 상태 + 등록/수정 제출. RN useWriteDiary 대응.
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/data/repositories/diary_repository.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_controller.dart';
import 'package:feeddiary/ui/features/diary/diary_list_controller.dart';
import 'package:feeddiary/ui/features/diary/monthly_diaries_provider.dart';
import 'package:feeddiary/ui/features/diary/sticker_catalog.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_diary_controller.freezed.dart';
part 'create_diary_controller.g.dart';

/// 작성/수정 폼 상태. RN useWriteDiary 의 diaryState(sticker/text/date).
@freezed
abstract class CreateDiaryFormState with _$CreateDiaryFormState {
  const factory CreateDiaryFormState({required String sticker, required String text, required DateTime date}) =
      _CreateDiaryFormState;

  const CreateDiaryFormState._();

  /// 등록 가능 조건 — 스티커 선택 + 본문 비어있지 않음. RN CustomButton disabled 의 긍정형.
  bool get canSubmit => sticker.isNotEmpty && text.trim().isNotEmpty;
}

/// 작성/수정 폼 컨트롤러. [initial]이 있으면 수정 모드(기존 값 시드), 없으면 새 작성.
@riverpod
class CreateDiaryController extends _$CreateDiaryController {
  @override
  CreateDiaryFormState build(MyDiary? initial) {
    return CreateDiaryFormState(
      sticker: initial?.sticker ?? StickerCatalog.defaultName,
      text: initial?.text ?? '',
      date: initial?.createdAt ?? _today(),
    );
  }

  void setSticker(String sticker) => state = state.copyWith(sticker: sticker);

  void setText(String text) => state = state.copyWith(text: text);

  void setDate(DateTime date) => state = state.copyWith(date: date);

  /// 등록 또는 수정. 성공 시 목록/월별 캐시를 무효화하고 생성된 일기 idx 를 반환. RN useWriteDiary.handleSubmitDiary.
  Future<int> submit() async {
    final repo = ref.read(diaryRepositoryProvider);
    final form = state;
    final target = initial;
    final idx = target == null
        ? await repo.createDiary(sticker: form.sticker, text: form.text, date: form.date)
        : await repo.editDiary(
            diaryIdx: target.idx,
            sticker: form.sticker,
            text: form.text,
            date: form.date,
            imageText: target.image,
          );
    ref.invalidate(diaryListProvider);
    ref.invalidate(monthlyDiariesProvider);
    // 수정이면 해당 상세 캐시도 무효화해 pushReplacement 후 최신 내용으로 다시 불러온다.
    if (target != null) {
      ref.invalidate(diaryDetailControllerProvider(target.idx));
    }
    return idx;
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
