// 설정 메뉴 항목 — 아이콘 + 라벨 + chevron 행. RN MenuButtonBox/MenuButton.
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:flutter/material.dart';

/// 설정 메인 화면의 메뉴 한 줄(잠금/문의/라이선스/버전). RN `MenuButton`(높이·chevron) 대응.
class SettingMenuItem extends StatelessWidget {
  const SettingMenuItem({required this.icon, required this.label, required this.onTap, super.key});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            Icon(icon, size: 20, color: context.colors.textSecondary),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
            Icon(Icons.chevron_right, color: context.colors.outline),
          ],
        ),
      ),
    );
  }
}
