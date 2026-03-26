import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_roles_web/core/utils/date_helper.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_event.dart';
import 'package:story_roles_web/presentation/screens/project/bloc/project_bloc.dart';
import 'package:story_roles_web/presentation/screens/project/widgets/add_chapter_dialog.dart';
import 'package:story_roles_web/presentation/screens/project/widgets/chapter_tile.dart';
import 'package:story_roles_web/presentation/screens/project/widgets/delete_dialog.dart';
import 'package:story_roles_web/presentation/screens/project/widgets/rename_dialog.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';

class ProjectScreen extends StatelessWidget {
  final Project project;

  const ProjectScreen({super.key, required this.project});

  Future<void> _showAddChapterDialog(BuildContext context) async {
    final nameController = TextEditingController();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AddChapterDialog(
            nameController: nameController,
            onConfirm: (name, content, file) {
              if (name.trim().isEmpty || content == null) return;
              context.read<ProjectBloc>().add(
                CreateChapterEvent(
                  projectId: project.id,
                  name: name.trim(),
                  content: content,
                ),
              );
            },
          ),
    );
    nameController.dispose();
  }

  Future<void> _showRenameDialog(BuildContext context, Chapter chapter) async {
    final controller = TextEditingController(text: chapter.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => RenameDialog(nameController: controller),
    );
    if (confirmed == true &&
        controller.text.trim().isNotEmpty &&
        context.mounted) {
      context.read<ProjectBloc>().add(
        RenameChapterEvent(
          chapterId: chapter.id,
          newName: controller.text.trim(),
        ),
      );
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Chapter chapter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => DeleteChapterDialog(chapterName: chapter.name),
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
                const Text(
                  'Failed to load project',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed:
                      () => context.read<ProjectBloc>().add(
                        LoadProjectEvent(project.id),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.go('/home'),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 14,
                        color: AppColors.onBackground.withValues(alpha: 0.5),
                      ),
                      label: Text(
                        'Projects',
                        style: TextStyle(
                          color: AppColors.onBackground.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            project.name,
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 28,
                            ),
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () => _showAddChapterDialog(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('New chapter'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: AppColors.onBackground.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Created ${formatDate(project.createdAt)}',
                          style: TextStyle(
                            color: AppColors.onBackground.withValues(
                              alpha: 0.4,
                            ),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Icon(
                          Icons.menu_book_outlined,
                          size: 13,
                          color: AppColors.onBackground.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${state.chapters.length} chapter${state.chapters.length == 1 ? '' : 's'}',
                          style: TextStyle(
                            color: AppColors.onBackground.withValues(
                              alpha: 0.4,
                            ),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: AppColors.divider),
                  ],
                ),
              ),
            ),

            if (state.chapters.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 48,
                        color: AppColors.onBackground.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No chapters yet.',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _showAddChapterDialog(context),
                        child: Text(
                          'Add the first chapter',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                sliver: SliverList.separated(
                  separatorBuilder:
                      (_, _) => Container(height: 1, color: AppColors.divider),
                  itemCount: state.chapters.length,
                  itemBuilder: (ctx, i) {
                    final chapter = state.chapters[i];
                    final tracks = state.tracksByChapter[chapter.id] ?? [];
                    final isGenerating = state.generatingChapterIds.contains(
                      chapter.id,
                    );
                    return ChapterTile(
                      chapter: chapter,
                      tracks: tracks,
                      isGenerating: isGenerating,
                      onRename: () => _showRenameDialog(context, chapter),
                      onDelete: () => _showDeleteDialog(context, chapter),
                      onPlayTrack:
                          (track) => context.read<PlayerBloc>().add(
                            PlayTrackEvent(track),
                          ),
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
