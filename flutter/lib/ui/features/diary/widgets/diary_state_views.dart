// 일기 상태 뷰 — 빈 목록/에러 표시 공용 위젯. RN EmptyStateView/ErrorView 대응.
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:flutter/material.dart';

/// 빈 목록 안내.
class DiaryEmptyView extends StatelessWidget {
  const DiaryEmptyView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco_outlined, size: 48, color: context.colors.outline),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: context.colors.textSecondary)),
        ],
      ),
    );
  }
}

/// 에러 + 재시도.
class DiaryErrorView extends StatelessWidget {
  const DiaryErrorView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: context.colors.error),
          const SizedBox(height: 12),
          Text('문제가 발생했어요.', style: TextStyle(color: context.colors.textSecondary)),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
