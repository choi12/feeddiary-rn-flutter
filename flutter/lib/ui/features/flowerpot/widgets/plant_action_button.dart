// 화분 액션 버튼 — 물주기/사랑주기(충전 수 배지 + 비활성). RN SidePanel ActionButton 대응.
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:flutter/material.dart';

/// 충전 수 배지가 달린 원형 액션 버튼. [enabled]가 false 면 흐리게 비활성(canWater/canLove).
class PlantActionButton extends StatelessWidget {
  const PlantActionButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? context.colors.primary : context.colors.outline;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Badge(
          isLabelVisible: count > 0,
          label: Text('$count'),
          child: Material(
            color: context.colors.surface,
            shape: CircleBorder(side: BorderSide(color: color, width: 1.5)),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: enabled ? onPressed : null,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Icon(icon, color: color),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
      ],
    );
  }
}
