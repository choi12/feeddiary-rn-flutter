// 디자인 토큰 L1(원시) — RN constants/ui/layout 매핑. 레이아웃 치수·간격·반경 상수.

/// 레이아웃 치수 토큰. 테마와 무관한 불변값이라 ThemeExtension 대신 정적 상수로 노출한다.
/// (색상은 테마 가능 → `context.colors`, 치수는 불변 → `AppDimens.x` 직접 참조.) RN `LAYOUT` 대응.
abstract final class AppDimens {
  static const double headerHeight = 70;
  static const double bottomTabHeight = 75;
  static const double inputHeight = 57;
  static const double buttonHeight = 54;

  /// 화면 좌우 기본 여백.
  static const double padding = 24;

  /// 카드·버튼 등 공통 모서리 반경.
  static const double borderRadius = 14;

  /// 일기/댓글 카드 모서리 반경. RN DiaryCard·CommentCard `borderRadius: 10`(공통 14와 별개).
  static const double cardRadius = 10;

  /// 안드로이드 하단 시스템 영역 보정값.
  static const double bottomInsetAndroid = 20;

  /// 하단 탭바 상단(좌우) 모서리 반경. RN `borderTopLeft/RightRadius: 20`.
  static const double tabBarTopRadius = 20;

  /// 토스트 박스 모서리 반경. RN `borderRadius: 10`.
  static const double toastRadius = 10;

  /// 알림 다이얼로그 너비. RN `AlertModal width: 300`.
  static const double dialogWidth = 300;

  /// 설정 메뉴 한 줄 높이. RN `MenuButton height: 70`.
  static const double menuRowHeight = 70;
}
