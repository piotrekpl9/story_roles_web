import 'package:flutter/material.dart';
import 'package:story_roles_web/core/utils/date_helper.dart';
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

class _TrackRowState extends State<TrackRow>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = widget.track.attributes.status == TrackStatus.completed;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: ready ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: ready ? widget.onPlay : null,
        child: ColoredBox(
          color: _hovered && ready ? AppColors.cardHover : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                Icon(
                  _hovered && ready ? Icons.play_arrow : Icons.headphones,
                  size: 18,
                  color: _hovered && ready
                      ? AppColors.primary
                      : AppColors.onBackground.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 12),
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
                const SizedBox(width: 16),
                Text(
                  formatDateTime(widget.track.attributes.createdAt),
                  style: TextStyle(
                    color: AppColors.onBackground.withValues(alpha: 0.55),
                    fontSize: 11,
                  ),
                ),
                if (widget.track.attributes.lectorVoice != null) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.person_outline, size: 12, color: AppColors.onBackground.withValues(alpha: 0.55)),
                  const SizedBox(width: 4),
                  Text(
                    widget.track.attributes.lectorVoice!,
                    style: TextStyle(
                      color: AppColors.onBackground.withValues(alpha: 0.55),
                      fontSize: 11,
                    ),
                  ),
                ],
                if (widget.track.attributes.emotion != null) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.mood, size: 12, color: AppColors.onBackground.withValues(alpha: 0.55)),
                  const SizedBox(width: 4),
                  Text(
                    widget.track.attributes.emotion!,
                    style: TextStyle(
                      color: AppColors.onBackground.withValues(alpha: 0.55),
                      fontSize: 11,
                    ),
                  ),
                ],
                const SizedBox(width: 16),
                if (ready)
                  const Text(
                    'Ready',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  )
                else
                  _AnimatedProcessing(controller: _dotsController),
                const SizedBox(width: 16),
                AnimatedOpacity(
                  opacity: _hovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: IconButton(
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

class _AnimatedProcessing extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedProcessing({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Processing',
              style: TextStyle(
                color: Colors.orange.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 2),
            _Dot(delay: 0.0, t: t),
            _Dot(delay: 0.2, t: t),
            _Dot(delay: 0.4, t: t),
          ],
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  final double delay;
  final double t;

  const _Dot({required this.delay, required this.t});

  @override
  Widget build(BuildContext context) {
    final phase = ((t - delay) % 1.0 + 1.0) % 1.0;
    // fade in first half, fade out second half
    final opacity = phase < 0.5 ? phase * 2 : (1.0 - phase) * 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Opacity(
        opacity: opacity.clamp(0.15, 1.0),
        child: Text(
          '.',
          style: TextStyle(
            color: Colors.orange.withValues(alpha: 0.9),
            fontSize: 14,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
