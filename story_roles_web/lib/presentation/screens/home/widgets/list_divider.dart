import 'package:flutter/material.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      const ColoredBox(color: AppColors.divider, child: SizedBox(height: 1));
}
