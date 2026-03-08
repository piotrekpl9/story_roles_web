import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/widgets/generic_input.dart';
import 'package:story_roles_web/presentation/screens/track_upload/bloc/track_upload_bloc.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';
import 'package:story_roles_web/presentation/widgets/button_primary.dart';

class TrackUploadView extends StatefulWidget {
  final VoidCallback onUploadSuccess;

  const TrackUploadView({super.key, required this.onUploadSuccess});

  @override
  State<TrackUploadView> createState() => _TrackUploadViewState();
}

class _TrackUploadViewState extends State<TrackUploadView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? v) {
    if (v == null || v.isEmpty) return 'Title is required';
    if (v.length > 100) return 'Title must be less than 100 characters';
    return null;
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final bytes = file.bytes;

      if (bytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not read file. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!mounted) return;
      context.read<TrackUploadBloc>().add(
            FileSelected(
              bytes: bytes,
              fileName: file.name,
              fileSize: bytes.length,
            ),
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleUpload(TrackUploadState state) {
    if (_formKey.currentState?.validate() ?? false) {
      if (state.selectedBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a file first'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      context.read<TrackUploadBloc>().add(
            UploadSubmitted(
              title: _titleController.text.trim(),
              bytes: state.selectedBytes!,
              fileName: state.fileName!,
            ),
          );
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrackUploadBloc, TrackUploadState>(
      listener: (context, state) {
        if (state.status == UploadStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _titleController.clear();
          context.read<TrackUploadBloc>().add(UploadReset());
          widget.onUploadSuccess();
        } else if (state.status == UploadStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Upload failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Upload Track',
                    style: AppTypography.titleLarge.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload your audio file to StoryRoles',
                    style: TextStyle(
                      color: AppColors.onBackground.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GenericInput(
                    controller: _titleController,
                    label: 'Track Title',
                    validator: _validateTitle,
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<TrackUploadBloc, TrackUploadState>(
                    builder: (context, state) {
                      final uploading = state.status == UploadStatus.uploading;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // File picker area
                          GestureDetector(
                            onTap: uploading ? null : _pickFile,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: 120,
                              decoration: BoxDecoration(
                                color: state.selectedBytes != null
                                    ? AppColors.primary.withValues(alpha: 0.08)
                                    : Colors.white.withValues(alpha: 0.04),
                                border: Border.all(
                                  color: state.selectedBytes != null
                                      ? AppColors.primary.withValues(alpha: 0.6)
                                      : Colors.white.withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: state.selectedBytes != null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: AppColors.primary,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          state.fileName ?? '',
                                          style: TextStyle(
                                            color: AppColors.onBackground,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (state.fileSize != null)
                                          Text(
                                            _formatSize(state.fileSize!),
                                            style: TextStyle(
                                              color: AppColors.onBackground
                                                  .withValues(alpha: 0.6),
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_outlined,
                                          color: AppColors.onBackground
                                              .withValues(alpha: 0.5),
                                          size: 36,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Click to choose a file',
                                          style: TextStyle(
                                            color: AppColors.onBackground
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          if (uploading)
                            const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF8A5B),
                              ),
                            )
                          else
                            ButtonPrimary(
                              label: 'Upload',
                              onPressed: state.selectedBytes != null
                                  ? () => _handleUpload(state)
                                  : null,
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
