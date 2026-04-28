import 'package:flutter/material.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class WordChip extends StatelessWidget {
  final String word;
  final bool isActive;
  final bool isPast;

  const WordChip({
    super.key,
    required this.word,
    required this.isActive,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final FontWeight weight;
    final double fontSize;

    if (isActive) {
      color = AppColors.primary;
      weight = FontWeight.w700;
      fontSize = 22;
    } else if (isPast) {
      color = AppColors.onBackground.withValues(alpha: 0.4);
      weight = FontWeight.w400;
      fontSize = 20;
    } else {
      color = AppColors.onBackground.withValues(alpha: 0.85);
      weight = FontWeight.w400;
      fontSize = 20;
    }

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 120),
      style: TextStyle(color: color, fontWeight: weight, fontSize: fontSize),
      child: Text(word),
    );
  }
}
