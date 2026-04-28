import 'package:flutter/material.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class EmptyScriptPlaceholder extends StatelessWidget {
  final bool isLoading;

  const EmptyScriptPlaceholder({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          isLoading
              ? const CircularProgressIndicator()
              : Text(
                'No script available',
                style: TextStyle(
                  color: AppColors.onBackground.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
              ),
    );
  }
}
