import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/presentation/screens/home/bloc/home_bloc.dart';
import 'package:story_roles_web/presentation/screens/home/widgets/list_divider.dart';
import 'package:story_roles_web/presentation/screens/home/widgets/new_project_dialog.dart';
import 'package:story_roles_web/presentation/screens/home/widgets/project_tile_list.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => NewProjectDialog(),
    );
    if (result != null && result.trim().isNotEmpty && context.mounted) {
      context.read<HomeBloc>().add(CreateProjectEvent(name: result.trim()));
    }
  }

  Future<void> _showRenameDialog(BuildContext context, Project project) async {
    final controller = TextEditingController(text: project.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: AppColors.card,
            title: const Text(
              'Rename project',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: controller,
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
              onSubmitted: (_) => Navigator.of(ctx).pop(true),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  'Rename',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
    );
    if (confirmed == true &&
        controller.text.trim().isNotEmpty &&
        context.mounted) {
      context.read<HomeBloc>().add(
        RenameProjectEvent(
          projectId: project.id,
          newName: controller.text.trim(),
        ),
      );
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: AppColors.card,
            title: const Text(
              'Remove project',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to remove "${project.name}"?',
              style: TextStyle(
                color: AppColors.onBackground.withValues(alpha: 0.7),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
    if (confirmed == true && context.mounted) {
      context.read<HomeBloc>().add(DeleteProjectEvent(projectId: project.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeBlocStatus.loading ||
            state.status == HomeBlocStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF8A5B)),
          );
        }
        if (state.status == HomeBlocStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Failed to load projects',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed:
                      () => context.read<HomeBloc>().add(LoadHomeEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final query = _searchController.text.toLowerCase();
        final filtered =
            query.isEmpty
                ? state.projects
                : state.projects
                    .where((p) => p.name.toLowerCase().contains(query))
                    .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
              child: Row(
                children: [
                  Text(
                    'Your Projects',
                    style: AppTypography.titleLarge.copyWith(fontSize: 26),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: () => _showCreateDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New project'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 260,
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: AppColors.onBackground.withValues(alpha: 0.4),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.onBackground.withValues(alpha: 0.5),
                        ),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  onPressed:
                                      () => setState(
                                        () => _searchController.clear(),
                                      ),
                                )
                                : null,
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Column headers
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
              child: Row(
                children: [
                  const SizedBox(width: 52),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(
                        color: AppColors.onBackground.withValues(alpha: 0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 96,
                    child: Text(
                      'Created',
                      style: TextStyle(
                        color: AppColors.onBackground.withValues(alpha: 0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 96),
                ],
              ),
            ),
            const ListDivider(),

            // List
            Expanded(
              child:
                  filtered.isEmpty
                      ? const Center(
                        child: Text(
                          'No projects found',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const ListDivider(),
                        itemBuilder: (ctx, i) {
                          final project = filtered[i];
                          return RepaintBoundary(
                            child: ProjectListTile(
                              project: project,
                              onTap:
                                  () => context.go(
                                    '/home/projects/${project.id}',
                                    extra: project,
                                  ),
                              onRename:
                                  () => _showRenameDialog(context, project),
                              onDelete:
                                  () => _showDeleteDialog(context, project),
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
