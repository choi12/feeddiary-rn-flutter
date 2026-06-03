// 일기 상태 뷰 — 빈 목록/에러 표시 공용 위젯. RN EmptyStateView/ErrorView 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';

/// 빈 목록 안내 — 회색조 레모니(35·opacity 0.7) + 안내 문구. RN EmptyStateView.
class DiaryEmptyView extends StatelessWidget {
  const DiaryEmptyView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0.7,
            child: Image.asset(AppAssets.lemonyGrayscale, width: 35, height: 35, fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 12, color: FeedPalette.lightGray),
          ),
        ],
      ),
    );
  }
}

/// 에러 + 재시도 — Feather alert-circle + 주황 안내 + 주황 재시도 버튼. RN ErrorView.
class DiaryErrorView extends StatelessWidget {
  const DiaryErrorView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FeedIcons.alert, size: 14, color: FeedPalette.orange),
              SizedBox(width: 4),
              Text(
                '잠시 후 다시 시도해 주세요.',
                style: TextStyle(
                  fontFamily: FeedFonts.dovemayo,
                  fontSize: 14,
                  color: FeedPalette.orange,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Material(
            color: FeedPalette.orange,
            borderRadius: BorderRadius.circular(7),
            child: InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(7),
              child: const SizedBox(
                width: 80,
                height: 40,
                child: Center(
                  child: Text(
                    '다시 시도',
                    style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
