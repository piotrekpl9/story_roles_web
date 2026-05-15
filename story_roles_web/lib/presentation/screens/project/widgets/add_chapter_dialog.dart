import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class AddChapterDialog extends StatefulWidget {
  final TextEditingController nameController;
  final void Function(String name, String content, Uint8List bytes, String fileName, String emotion) onConfirm;

  const AddChapterDialog({
    super.key,
    required this.nameController,
    required this.onConfirm,
  });

  @override
  State<AddChapterDialog> createState() => _AddChapterDialogState();
}

class _AddChapterDialogState extends State<AddChapterDialog> {
  static const int _maxFileSizeBytes = 1 * 1024 * 1024;
  static const _emotions = ['neutral', 'expressive', 'calm'];

  String? _fileName;
  String? _fileContent;
  Uint8List? _fileBytes;
  bool _picking = false;
  String? _fileError;
  String _selectedEmotion = 'neutral';

  Future<void> _pickFile() async {
    setState(() {
      _picking = true;
      _fileError = null;
    });
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        withData: true,
      );
      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        if (bytes.length > _maxFileSizeBytes) {
          setState(() {
            _fileError = 'File is too large. Maximum size is 1 MB.';
            _fileName = null;
            _fileContent = null;
            _fileBytes = null;
          });
          return;
        }
        setState(() {
          _fileName = result.files.single.name;
          _fileContent = utf8.decode(bytes);
          _fileBytes = bytes;
        });
      }
    } finally {
      setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm =
        widget.nameController.text.trim().isNotEmpty && _fileContent != null;

    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text('New chapter', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            TextField(
              controller: widget.nameController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Chapter name',
                labelStyle: TextStyle(
                  color: AppColors.onBackground.withValues(alpha: 0.65),
                ),
                hintText: 'e.g. Chapter 1 – The Beginning',
                hintStyle: TextStyle(
                  color: AppColors.onBackground.withValues(alpha: 0.5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // File picker
            Text(
              'Source file (.txt)',
              style: TextStyle(
                color: AppColors.onBackground.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _picking ? null : _pickFile,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color:
                      _fileContent != null
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : Colors.white.withValues(alpha: 0.04),
                  border: Border.all(
                    color:
                        _fileContent != null
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : AppColors.divider,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _fileContent != null
                          ? Icons.check_circle_outline
                          : Icons.upload_file_outlined,
                      size: 20,
                      color:
                          _fileContent != null
                              ? AppColors.primary
                              : AppColors.onBackground.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:
                          _picking
                              ? Text(
                                'Picking file...',
                                style: TextStyle(
                                  color: AppColors.onBackground.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 14,
                                ),
                              )
                              : Text(
                                _fileName ?? 'Click to select a .txt file',
                                style: TextStyle(
                                  color:
                                      _fileContent != null
                                          ? AppColors.onBackground
                                          : AppColors.onBackground.withValues(
                                            alpha: 0.4,
                                          ),
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                    ),
                    if (_fileContent != null)
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 16,
                          color: AppColors.onBackground.withValues(alpha: 0.6),
                        ),
                        onPressed:
                            () => setState(() {
                              _fileName = null;
                              _fileContent = null;
                              _fileBytes = null;
                            }),
                        splashRadius: 14,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ),
            ),
            if (_fileError != null) ...[
              const SizedBox(height: 6),
              Text(
                _fileError!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 11),
              ),
            ] else if (_fileContent != null) ...[
              const SizedBox(height: 6),
              Text(
                '${_fileContent!.length} characters',
                style: TextStyle(
                  color: AppColors.onBackground.withValues(alpha: 0.55),
                  fontSize: 11,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'Emotion',
              style: TextStyle(
                color: AppColors.onBackground.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedEmotion,
              dropdownColor: AppColors.card,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: AppColors.onBackground.withValues(alpha: 0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              items: _emotions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedEmotion = v);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        FilledButton(
          onPressed:
              canConfirm
                  ? () {
                    widget.onConfirm(
                      widget.nameController.text,
                      _fileContent!,
                      _fileBytes!,
                      _fileName!,
                      _selectedEmotion,
                    );
                    Navigator.of(context).pop();
                  }
                  : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
          ),
          child: const Text('Create', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
