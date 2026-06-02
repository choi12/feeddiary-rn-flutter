// 비밀번호 점 표시 — 4칸 중 입력분만 채워 표시. RN components/lock/PasswordBox(점).
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:flutter/material.dart';

/// 입력 자리 수만큼 점을 채워 보여 주는 표시기. RN `PasswordBox`의 점 오버레이 대응.
class PasswordDots extends StatelessWidget {
  const PasswordDots({required this.filled, this.length = 4, super.key});

  /// 채워진(입력된) 자리 수.
  final int filled;

  /// 전체 자리 수(기본 4).
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < length; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled ? context.colors.primary : context.colors.outline,
            ),
          ),
      ],
    );
  }
}
