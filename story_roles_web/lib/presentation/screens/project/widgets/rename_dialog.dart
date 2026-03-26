import 'package:flutter/material.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class RenameDialog extends StatefulWidget {
  final TextEditingController nameController;
  const RenameDialog({super.key, required this.nameController});

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text(
        'Rename chapter',
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: widget.nameController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Chapter name',
          hintStyle: TextStyle(
            color: AppColors.onBackground.withValues(alpha: 0.4),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
        onSubmitted: (_) => Navigator.of(context).pop(true),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Rename', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}
