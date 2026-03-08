import 'package:flutter/material.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class AppTypography {
  static const TextStyle titleLarge = TextStyle(
    fontSize: 32,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle labelRegular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle inputLabelRegular = TextStyle(color: AppColors.onBackground);
}
