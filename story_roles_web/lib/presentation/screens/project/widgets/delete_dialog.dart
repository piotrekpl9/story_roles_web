import 'package:flutter/material.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class DeleteChapterDialog extends StatelessWidget {
  final String chapterName;
  const DeleteChapterDialog({super.key, required this.chapterName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text(
        'Remove chapter',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        'Are you sure you want to remove "$chapterName"?',
        style: TextStyle(color: AppColors.onBackground.withValues(alpha: 0.7)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Remove',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
