import 'package:flutter/material.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class TrackRow extends StatefulWidget {
  final Track track;
  final int chapterId;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  const TrackRow({
    super.key,
    required this.track,
    required this.chapterId,
    required this.onPlay,
    required this.onDelete,
  });

  @override
  State<TrackRow> createState() => _TrackRowState();
}

class _TrackRowState extends State<TrackRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ready = widget.track.attributes.status.name == 'completed';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: ready ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: ready ? widget.onPlay : null,
        child: ColoredBox(
          color: _hovered && ready ? AppColors.cardHover : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Icon(
                  _hovered && ready ? Icons.play_arrow : Icons.headphones,
                  size: 16,
                  color:
                      _hovered && ready
                          ? AppColors.primary
                          : AppColors.onBackground.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.track.attributes.title,
                    style: TextStyle(
                      color:
                          _hovered && ready
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
                    ? const Text(
                      'Ready',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    )
                    : Text(
                      'Processing',
                      style: TextStyle(
                        color: Colors.orange.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                if (_hovered)
                  IconButton(
                    tooltip: 'Remove',
                    icon: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.redAccent.withValues(alpha: 0.8),
                    ),
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
