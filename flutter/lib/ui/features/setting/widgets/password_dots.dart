// 비밀번호 표시 — 4칸 레모니 캐릭터(회색 바닥 + 입력분만 컬러 점등). RN components/lock/PasswordBox + PasswordDot.
import 'package:feeddiary/config/app_assets.dart';
import 'package:flutter/material.dart';

/// 입력 자리 수만큼 레모니 캐릭터를 컬러로 점등하는 표시기. RN `PasswordBox`(회색 레모니 위에 컬러 레모니를 opacity 로 토글하는 2겹 스택) 대응.
class PasswordDots extends StatelessWidget {
  const PasswordDots({required this.filled, this.length = 4, super.key});

  /// 채워진(입력된) 자리 수.
  final int filled;

  /// 전체 자리 수(기본 4).
  final int length;

  /// RN `PasswordDot` 렌더 치수(30×30 contain).
  static const double _size = 30;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          SizedBox(
            width: _size,
            height: _size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AppAssets.lemonyGrayscale, fit: BoxFit.contain),
                Opacity(
                  opacity: i < filled ? 1 : 0,
                  child: Image.asset(AppAssets.lemony3Preview, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
