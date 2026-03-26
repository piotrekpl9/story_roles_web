import 'package:flutter/material.dart';
import 'package:story_roles_web/core/utils/date_helper.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class ProjectListTile extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const ProjectListTile({
    super.key,
    required this.project,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  State<ProjectListTile> createState() => _ProjectListTileState();
}

class _ProjectListTileState extends State<ProjectListTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ColoredBox(
          color: _hovered ? AppColors.cardHover : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Icon
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.folder_outlined,
                      color: _hovered ? AppColors.primary : Colors.white54,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Name
                Expanded(
                  child: Text(
                    widget.project.name,
                    style: TextStyle(
                      color: _hovered ? AppColors.primary : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Date
                SizedBox(
                  width: 96,
                  child: Text(
                    formatDate(widget.project.createdAt),
                    style: TextStyle(
                      color: AppColors.onBackground.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ),

                // Actions
                SizedBox(
                  width: 96,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: 'Rename',
                        icon: Icon(
                          Icons.drive_file_rename_outline,
                          size: 18,
                          color:
                              _hovered
                                  ? AppColors.onBackground.withValues(
                                    alpha: 0.7,
                                  )
                                  : Colors.transparent,
                        ),
                        onPressed: widget.onRename,
                        splashRadius: 18,
                      ),
                      IconButton(
                        tooltip: 'Remove',
                        icon: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color:
                              _hovered
                                  ? Colors.redAccent.withValues(alpha: 0.8)
                                  : Colors.transparent,
                        ),
                        onPressed: widget.onDelete,
                        splashRadius: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
