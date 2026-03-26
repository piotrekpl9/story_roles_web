import 'package:flutter/material.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.onBackground.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: AppColors.onBackground.withValues(alpha: 0.45),
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
