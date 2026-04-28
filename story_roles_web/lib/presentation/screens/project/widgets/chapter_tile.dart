import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/utils/date_helper.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';
import 'package:story_roles_web/domain/entities/lector_voice.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/repositories/lector_voice_repository.dart';
import 'package:story_roles_web/presentation/screens/project/bloc/project_bloc.dart';
import 'package:story_roles_web/presentation/screens/project/widgets/track_row.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class ChapterTile extends StatefulWidget {
  final Chapter chapter;
  final List<Track> tracks;
  final bool isGenerating;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final ValueChanged<Track> onPlayTrack;

  const ChapterTile({
    super.key,
    required this.chapter,
    required this.tracks,
    required this.isGenerating,
    required this.onRename,
    required this.onDelete,
    required this.onPlayTrack,
  });

  @override
  State<ChapterTile> createState() => _ChapterTileState();
}

class _ChapterTileState extends State<ChapterTile> {
  bool _expanded = false;
  bool _showContent = false;
  bool _hovered = false;

  Future<void> _pickNewFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return;
    final content = String.fromCharCodes(result.files.single.bytes!);
    if (context.mounted) {
      context.read<ProjectBloc>().add(
        UpdateChapterContentEvent(
          chapterId: widget.chapter.id,
          content: content,
        ),
      );
    }
  }

  Future<void> _showNarratorDialog(BuildContext context) async {
    final bloc = context.read<ProjectBloc>();
    final voices = bloc.state.lectorVoices;
    final repo = context.read<LectorVoiceRepository>();
    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => _NarratorDialog(voices: voices, repository: repo),
    );
    if (selected != null && context.mounted) {
      bloc.add(
        GenerateTracksEvent(widget.chapter.projectId, widget.chapter.id, selected),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = widget.chapter.content != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter header row
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: ColoredBox(
              color: _hovered ? AppColors.cardHover : Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    // Expand chevron
                    AnimatedRotation(
                      turns: _expanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        Icons.chevron_right,
                        color: AppColors.onBackground.withValues(alpha: 0.5),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Chapter icon
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        hasContent
                            ? Icons.article_outlined
                            : Icons.upload_file_outlined,
                        color:
                            hasContent
                                ? AppColors.primary.withValues(alpha: 0.8)
                                : Colors.white38,
                        size: 17,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name + meta
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.chapter.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                formatDate(widget.chapter.createdAt),
                                style: TextStyle(
                                  color: AppColors.onBackground.withValues(
                                    alpha: 0.4,
                                  ),
                                  fontSize: 12,
                                ),
                              ),
                              if (!hasContent) ...[
                                const SizedBox(width: 8),
                                Text(
                                  'No file uploaded',
                                  style: TextStyle(
                                    color: Colors.orange.withValues(alpha: 0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              if (widget.tracks.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.headphones,
                                  size: 12,
                                  color: AppColors.onBackground.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.tracks.length} track${widget.tracks.length == 1 ? '' : 's'}',
                                  style: TextStyle(
                                    color: AppColors.onBackground.withValues(
                                      alpha: 0.4,
                                    ),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Generate audio button (only when content exists)
                    if (hasContent && _hovered || widget.isGenerating)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child:
                            widget.isGenerating
                                ? SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Generating…',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : OutlinedButton.icon(
                                  onPressed: () => _showNarratorDialog(context),
                                  icon: const Icon(Icons.graphic_eq, size: 15),
                                  label: const Text(
                                    'Generate audio',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: BorderSide(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                  ),
                                ),
                      ),

                    // Rename / change file / delete
                    if (_hovered) ...[
                      IconButton(
                        tooltip: 'Change source file',
                        icon: Icon(
                          Icons.upload_file_outlined,
                          size: 17,
                          color: AppColors.onBackground.withValues(alpha: 0.7),
                        ),
                        onPressed: () => _pickNewFile(context),
                        splashRadius: 16,
                      ),
                      IconButton(
                        tooltip: 'Rename',
                        icon: Icon(
                          Icons.drive_file_rename_outline,
                          size: 17,
                          color: AppColors.onBackground.withValues(alpha: 0.7),
                        ),
                        onPressed: widget.onRename,
                        splashRadius: 16,
                      ),
                      IconButton(
                        tooltip: 'Remove',
                        icon: Icon(
                          Icons.delete_outline,
                          size: 17,
                          color: Colors.redAccent.withValues(alpha: 0.8),
                        ),
                        onPressed: widget.onDelete,
                        splashRadius: 16,
                      ),
                    ] else
                      const SizedBox(width: 96),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Source text (expanded)
        if (_expanded && widget.chapter.content != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 52, right: 8, bottom: 4),
            child: GestureDetector(
              onTap: () => setState(() => _showContent = !_showContent),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedRotation(
                    turns: _showContent ? 0.25 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.chevron_right,
                      size: 15,
                      color: AppColors.onBackground.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Source text',
                    style: TextStyle(
                      color: AppColors.onBackground.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showContent)
            Padding(
              padding: const EdgeInsets.only(left: 52, right: 8, bottom: 8),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(
                      widget.chapter.content!,
                      style: TextStyle(
                        color: AppColors.onBackground.withValues(alpha: 0.75),
                        fontSize: 13,
                        height: 1.6,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],

        // Track list (expanded)
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(left: 52, bottom: 8),
            child:
                widget.tracks.isEmpty
                    ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        hasContent
                            ? 'No tracks yet — click "Generate audio" to start.'
                            : 'Upload a .txt file first to generate audio.',
                        style: TextStyle(
                          color: AppColors.onBackground.withValues(alpha: 0.35),
                          fontSize: 13,
                        ),
                      ),
                    )
                    : Column(
                      children:
                          widget.tracks
                              .map(
                                (t) => TrackRow(
                                  track: t,
                                  chapterId: widget.chapter.id,
                                  onPlay: () => widget.onPlayTrack(t),
                                  onDelete:
                                      () => context.read<ProjectBloc>().add(
                                        DeleteTrackEvent(
                                          trackId: t.id,
                                          chapterId: widget.chapter.id,
                                        ),
                                      ),
                                ),
                              )
                              .toList(),
                    ),
          ),
      ],
    );
  }
}

class _NarratorDialog extends StatefulWidget {
  final List<LectorVoice> voices;
  final LectorVoiceRepository repository;

  const _NarratorDialog({required this.voices, required this.repository});

  @override
  State<_NarratorDialog> createState() => _NarratorDialogState();
}

class _NarratorDialogState extends State<_NarratorDialog> {
  final ap.AudioPlayer _player = ap.AudioPlayer();
  String? _playingId;
  bool _loading = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggleSample(String id) async {
    if (_playingId == id) {
      await _player.stop();
      setState(() => _playingId = null);
      return;
    }
    setState(() {
      _playingId = id;
      _loading = true;
    });
    try {
      final bytes = await widget.repository.getSample(id);
      await _player.stop();
      await _player.setSourceBytes(bytes);
      await _player.resume();
      _player.onPlayerComplete.first.then((_) {
        if (mounted && _playingId == id) setState(() => _playingId = null);
      });
    } catch (_) {
      // ignore sample errors
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: AppColors.card,
      title: const Text(
        'Choose narrator',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      children: widget.voices.map((v) {
        final isPlaying = _playingId == v.id;
        final isLoadingThis = _loading && _playingId == v.id;
        return SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(v.id),
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 20,
                color: AppColors.onBackground.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.name,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    if (v.description.isNotEmpty)
                      Text(
                        v.description,
                        style: TextStyle(
                          color: AppColors.onBackground.withValues(alpha: 0.45),
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _toggleSample(v.id),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: isLoadingThis
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : Icon(
                          isPlaying ? Icons.stop : Icons.play_arrow,
                          size: 18,
                          color: AppColors.primary,
                        ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
