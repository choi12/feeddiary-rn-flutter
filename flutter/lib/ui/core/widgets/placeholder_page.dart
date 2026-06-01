// 라우팅 골격용 placeholder 화면 — 실제 기능 화면은 각 기능 PR에서 대체.
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:flutter/material.dart';

/// PR① scaffolding 단계의 임시 화면. 라우트가 가리킬 실제 화면(SignIn/Home 등)은
/// 기능 PR에서 구현하며, 그 전까지 라우팅·테마 골격을 시각적으로 확인하는 용도다.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: context.colors.textPrimary),
        ),
      ),
    );
  }
}
