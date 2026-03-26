import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_event.dart';
import 'package:story_roles_web/presentation/screens/project/bloc/project_bloc.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';

class ProjectScreen extends StatelessWidget {
  final Project project;

  const ProjectScreen({super.key, required this.project});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  Future<void> _showAddChapterDialog(BuildContext context) async {
    final nameController = TextEditingController();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _AddChapterDialog(
        nameController: nameController,
        onConfirm: (name, content, file) {
          if (name.trim().isEmpty || content == null) return;
          context.read<ProjectBloc>().add(CreateChapterEvent(
                projectId: project.id,
                name: name.trim(),
                content: content,
              ));
        },
      ),
    );
    nameController.dispose();
  }

  Future<void> _showRenameDialog(BuildContext context, Chapter chapter) async {
    final controller = TextEditingController(text: chapter.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Rename chapter',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Chapter name',
            hintStyle: TextStyle(
                color: AppColors.onBackground.withValues(alpha: 0.4)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.divider)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary)),
          ),
          onSubmitted: (_) => Navigator.of(ctx).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Rename', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
    if (confirmed == true &&
        controller.text.trim().isNotEmpty &&
        context.mounted) {
      context.read<ProjectBloc>().add(RenameChapterEvent(
            chapterId: chapter.id,
            newName: controller.text.trim(),
          ));
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Chapter chapter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Remove chapter',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove "${chapter.name}"?',
          style: TextStyle(
              color: AppColors.onBackground.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<ProjectBloc>().add(DeleteChapterEvent(chapter.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state.status == ProjectStatus.loading ||
            state.status == ProjectStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF8A5B)),
          );
        }
        if (state.status == ProjectStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Failed to load project',
                    style: TextStyle(color: Colors.white54, fontSize: 16)),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context
                      .read<ProjectBloc>()
                      .add(LoadProjectEvent(project.id)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.go('/home'),
                      icon: Icon(Icons.arrow_back_ios_new,
                          size: 14,
                          color: AppColors.onBackground.withValues(alpha: 0.5)),
                      label: Text('Projects',
                          style: TextStyle(
                              color:
                                  AppColors.onBackground.withValues(alpha: 0.5),
                              fontSize: 13)),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(project.name,
                              style:
                                  AppTypography.titleLarge.copyWith(fontSize: 28)),
                        ),
                        FilledButton.icon(
                          onPressed: () => _showAddChapterDialog(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('New chapter'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 13,
                            color: AppColors.onBackground.withValues(alpha: 0.4)),
                        const SizedBox(width: 6),
                        Text(
                          'Created ${_formatDate(project.createdAt)}',
                          style: TextStyle(
                              color:
                                  AppColors.onBackground.withValues(alpha: 0.4),
                              fontSize: 13),
                        ),
                        const SizedBox(width: 20),
                        Icon(Icons.menu_book_outlined,
                            size: 13,
                            color: AppColors.onBackground.withValues(alpha: 0.4)),
                        const SizedBox(width: 6),
                        Text(
                          '${state.chapters.length} chapter${state.chapters.length == 1 ? '' : 's'}',
                          style: TextStyle(
                              color:
                                  AppColors.onBackground.withValues(alpha: 0.4),
                              fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: AppColors.divider),
                  ],
                ),
              ),
            ),

            // ── Chapter list ──────────────────────────────────────────
            if (state.chapters.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_outlined,
                          size: 48,
                          color: AppColors.onBackground.withValues(alpha: 0.2)),
                      const SizedBox(height: 16),
                      Text('No chapters yet.',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 16)),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _showAddChapterDialog(context),
                        child: Text('Add the first chapter',
                            style: TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                sliver: SliverList.separated(
                  separatorBuilder: (_, _) =>
                      Container(height: 1, color: AppColors.divider),
                  itemCount: state.chapters.length,
                  itemBuilder: (ctx, i) {
                    final chapter = state.chapters[i];
                    final tracks =
                        state.tracksByChapter[chapter.id] ?? [];
                    final isGenerating =
                        state.generatingChapterIds.contains(chapter.id);
                    return _ChapterTile(
                      chapter: chapter,
                      tracks: tracks,
                      isGenerating: isGenerating,
                      onRename: () => _showRenameDialog(context, chapter),
                      onDelete: () => _showDeleteDialog(context, chapter),
                      onPlayTrack: (track) => context
                          .read<PlayerBloc>()
                          .add(PlayTrackEvent(track)),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

// ── Add chapter dialog ────────────────────────────────────────────────────────

class _AddChapterDialog extends StatefulWidget {
  final TextEditingController nameController;
  final void Function(String name, String? content, String? fileName) onConfirm;

  const _AddChapterDialog({
    required this.nameController,
    required this.onConfirm,
  });

  @override
  State<_AddChapterDialog> createState() => _AddChapterDialogState();
}

class _AddChapterDialogState extends State<_AddChapterDialog> {
  String? _fileName;
  String? _fileContent;
  bool _picking = false;

  Future<void> _pickFile() async {
    setState(() => _picking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        withData: true,
      );
      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        setState(() {
          _fileName = result.files.single.name;
          _fileContent = String.fromCharCodes(bytes);
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
                    color: AppColors.onBackground.withValues(alpha: 0.5)),
                hintText: 'e.g. Chapter 1 – The Beginning',
                hintStyle: TextStyle(
                    color: AppColors.onBackground.withValues(alpha: 0.3)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.divider)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 24),

            // File picker
            Text('Source file (.txt)',
                style: TextStyle(
                    color: AppColors.onBackground.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _picking ? null : _pickFile,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _fileContent != null
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.04),
                  border: Border.all(
                    color: _fileContent != null
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
                      color: _fileContent != null
                          ? AppColors.primary
                          : AppColors.onBackground.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _picking
                          ? Text('Picking file...',
                              style: TextStyle(
                                  color: AppColors.onBackground
                                      .withValues(alpha: 0.5),
                                  fontSize: 14))
                          : Text(
                              _fileName ?? 'Click to select a .txt file',
                              style: TextStyle(
                                color: _fileContent != null
                                    ? AppColors.onBackground
                                    : AppColors.onBackground
                                        .withValues(alpha: 0.4),
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    if (_fileContent != null)
                      IconButton(
                        icon: Icon(Icons.close,
                            size: 16,
                            color: AppColors.onBackground
                                .withValues(alpha: 0.4)),
                        onPressed: () =>
                            setState(() {
                              _fileName = null;
                              _fileContent = null;
                            }),
                        splashRadius: 14,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ),
            ),
            if (_fileContent != null) ...[
              const SizedBox(height: 6),
              Text(
                '${_fileContent!.length} characters',
                style: TextStyle(
                    color: AppColors.onBackground.withValues(alpha: 0.35),
                    fontSize: 11),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child:
              const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        FilledButton(
          onPressed: canConfirm
              ? () {
                  widget.onConfirm(
                    widget.nameController.text,
                    _fileContent,
                    _fileName,
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

// ── Chapter tile ──────────────────────────────────────────────────────────────

class _ChapterTile extends StatefulWidget {
  final Chapter chapter;
  final List<Track> tracks;
  final bool isGenerating;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final ValueChanged<Track> onPlayTrack;

  const _ChapterTile({
    required this.chapter,
    required this.tracks,
    required this.isGenerating,
    required this.onRename,
    required this.onDelete,
    required this.onPlayTrack,
  });

  @override
  State<_ChapterTile> createState() => _ChapterTileState();
}

class _ChapterTileState extends State<_ChapterTile> {
  bool _expanded = false;
  bool _showContent = false;
  bool _hovered = false;

  static const _narrators = [
    ('Andrzej', Icons.person_outline),
    ('Maria', Icons.person_outline),
    ('Tomasz', Icons.person_outline),
    ('Krzysztof', Icons.person_outline),
  ];

  Future<void> _pickNewFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return;
    final content = String.fromCharCodes(result.files.single.bytes!);
    if (context.mounted) {
      context.read<ProjectBloc>().add(UpdateChapterContentEvent(
            chapterId: widget.chapter.id,
            content: content,
          ));
    }
  }

  Future<void> _showNarratorDialog(BuildContext context) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: AppColors.card,
        title: const Text('Choose narrator',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        children: _narrators
            .map((n) => SimpleDialogOption(
                  onPressed: () => Navigator.of(ctx).pop(n.$1),
                  child: Row(
                    children: [
                      Icon(n.$2,
                          size: 20,
                          color: AppColors.onBackground.withValues(alpha: 0.6)),
                      const SizedBox(width: 12),
                      Text(n.$1,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
    if (selected != null && context.mounted) {
      context
          .read<ProjectBloc>()
          .add(GenerateTracksEvent(widget.chapter.id, selected));
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
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
                        color: hasContent
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
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _formatDate(widget.chapter.createdAt),
                                style: TextStyle(
                                    color: AppColors.onBackground
                                        .withValues(alpha: 0.4),
                                    fontSize: 12),
                              ),
                              if (!hasContent) ...[
                                const SizedBox(width: 8),
                                Text('No file uploaded',
                                    style: TextStyle(
                                        color: Colors.orange
                                            .withValues(alpha: 0.7),
                                        fontSize: 12)),
                              ],
                              if (widget.tracks.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.headphones,
                                    size: 12,
                                    color: AppColors.onBackground
                                        .withValues(alpha: 0.4)),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.tracks.length} track${widget.tracks.length == 1 ? '' : 's'}',
                                  style: TextStyle(
                                      color: AppColors.onBackground
                                          .withValues(alpha: 0.4),
                                      fontSize: 12),
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
                        child: widget.isGenerating
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
                                    Text('Generating…',
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 12)),
                                  ],
                                ),
                              )
                            : OutlinedButton.icon(
                                onPressed: () => _showNarratorDialog(context),
                                icon: const Icon(Icons.graphic_eq, size: 15),
                                label: const Text('Generate audio',
                                    style: TextStyle(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: BorderSide(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  minimumSize: Size.zero,
                                ),
                              ),
                      ),

                    // Rename / change file / delete
                    if (_hovered) ...[
                      IconButton(
                        tooltip: 'Change source file',
                        icon: Icon(Icons.upload_file_outlined,
                            size: 17,
                            color: AppColors.onBackground.withValues(alpha: 0.7)),
                        onPressed: () => _pickNewFile(context),
                        splashRadius: 16,
                      ),
                      IconButton(
                        tooltip: 'Rename',
                        icon: Icon(Icons.drive_file_rename_outline,
                            size: 17,
                            color: AppColors.onBackground
                                .withValues(alpha: 0.7)),
                        onPressed: widget.onRename,
                        splashRadius: 16,
                      ),
                      IconButton(
                        tooltip: 'Remove',
                        icon: Icon(Icons.delete_outline,
                            size: 17,
                            color: Colors.redAccent.withValues(alpha: 0.8)),
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
                    child: Icon(Icons.chevron_right,
                        size: 15,
                        color: AppColors.onBackground.withValues(alpha: 0.4)),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Source text',
                    style: TextStyle(
                        color: AppColors.onBackground.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4),
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
                          fontFamily: 'monospace'),
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
            child: widget.tracks.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      hasContent
                          ? 'No tracks yet — click "Generate audio" to start.'
                          : 'Upload a .txt file first to generate audio.',
                      style: TextStyle(
                          color: AppColors.onBackground.withValues(alpha: 0.35),
                          fontSize: 13),
                    ),
                  )
                : Column(
                    children: widget.tracks
                        .map((t) => _TrackRow(
                              track: t,
                              chapterId: widget.chapter.id,
                              onPlay: () => widget.onPlayTrack(t),
                              onDelete: () => context
                                  .read<ProjectBloc>()
                                  .add(DeleteTrackEvent(
                                    trackId: t.id,
                                    chapterId: widget.chapter.id,
                                  )),
                            ))
                        .toList(),
                  ),
          ),
      ],
    );
  }
}

// ── Track row ─────────────────────────────────────────────────────────────────

class _TrackRow extends StatefulWidget {
  final Track track;
  final int chapterId;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  const _TrackRow({
    required this.track,
    required this.chapterId,
    required this.onPlay,
    required this.onDelete,
  });

  @override
  State<_TrackRow> createState() => _TrackRowState();
}

class _TrackRowState extends State<_TrackRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ready = widget.track.attributes.status.name == 'completed';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor:
          ready ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: ready ? widget.onPlay : null,
        child: ColoredBox(
          color: _hovered && ready
              ? AppColors.cardHover
              : Colors.transparent,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Icon(
                  _hovered && ready
                      ? Icons.play_arrow
                      : Icons.headphones,
                  size: 16,
                  color: _hovered && ready
                      ? AppColors.primary
                      : AppColors.onBackground.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.track.attributes.title,
                    style: TextStyle(
                      color: _hovered && ready
                          ? AppColors.primary
                          : AppColors.onBackground.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                ready
                    ? const Text('Ready',
                        style: TextStyle(color: Colors.green, fontSize: 12))
                    : Text('Processing',
                        style: TextStyle(
                            color: Colors.orange.withValues(alpha: 0.8),
                            fontSize: 12)),
                if (_hovered)
                  IconButton(
                    tooltip: 'Remove',
                    icon: Icon(Icons.delete_outline,
                        size: 16,
                        color: Colors.redAccent.withValues(alpha: 0.8)),
                    onPressed: widget.onDelete,
                    splashRadius: 14,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  const SizedBox(width: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
