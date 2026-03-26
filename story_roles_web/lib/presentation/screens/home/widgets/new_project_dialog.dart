import 'package:flutter/material.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class NewProjectDialog extends StatefulWidget {
  const NewProjectDialog({super.key});

  @override
  State<NewProjectDialog> createState() => _NewProjectDialogState();
}

class _NewProjectDialogState extends State<NewProjectDialog> {
  late final TextEditingController _projectNameController;

  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text('New project', style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: _projectNameController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Project name',
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
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        TextButton(
          onPressed:
              () => Navigator.of(context).pop(_projectNameController.text),
          child: Text('Create', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}
