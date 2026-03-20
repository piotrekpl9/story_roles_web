import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/domain/entities/player_state.dart'
    show PlaybackStatus;
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/entities/track_progress.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc_state.dart';
import 'package:story_roles_web/presentation/screens/home/bloc/home_bloc.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';

class HomeView extends StatefulWidget {
  final ValueChanged<Track> onTrackSelected;

  const HomeView({super.key, required this.onTrackSelected});

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

  Future<void> _showRenameDialog(BuildContext context, Track track) async {
    final controller = TextEditingController(text: track.attributes.title);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Rename track',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Track name',
            hintStyle:
                TextStyle(color: AppColors.onBackground.withValues(alpha: 0.4)),
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
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child:
                Text('Rename', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      if (context.mounted) {
        context.read<HomeBloc>().add(RenameTrackEvent(
            trackId: track.id, newTitle: controller.text.trim()));
      }
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Track track) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Remove track',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove "${track.attributes.title}"?',
          style: TextStyle(
              color: AppColors.onBackground.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
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
      context.read<HomeBloc>().add(DeleteTrackEvent(trackId: track.id));
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
                const Text('Failed to load tracks',
                    style: TextStyle(color: Colors.white54, fontSize: 16)),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      context.read<HomeBloc>().add(LoadHomeEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final query = _searchController.text.toLowerCase();
        final filtered = query.isEmpty
            ? state.tracks
            : state.tracks
                .where((t) =>
                    t.attributes.title.toLowerCase().contains(query))
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
              child: Row(
                children: [
                  Text('Your Library',
                      style: AppTypography.titleLarge.copyWith(fontSize: 26)),
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
                            color: AppColors.onBackground
                                .withValues(alpha: 0.4)),
                        prefixIcon: Icon(Icons.search,
                            color: AppColors.onBackground
                                .withValues(alpha: 0.5)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: Colors.white, size: 18),
                                onPressed: () =>
                                    setState(() => _searchController.clear()),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
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
                    child: Text('Title',
                        style: TextStyle(
                          color:
                              AppColors.onBackground.withValues(alpha: 0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        )),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text('Status',
                        style: TextStyle(
                          color:
                              AppColors.onBackground.withValues(alpha: 0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        )),
                  ),
                  const SizedBox(width: 96),
                ],
              ),
            ),
            const _ListDivider(),

            // List
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('No tracks found',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 16)),
                    )
                  : BlocSelector<PlayerBloc, PlayerBlocState, (int, bool)>(
                      selector: (s) => (
                        s.currentTrack?.id ?? -1,
                        s.playerState.status == PlaybackStatus.playing,
                      ),
                      builder: (context, playerInfo) {
                        final (currentTrackId, isActuallyPlaying) = playerInfo;
                        return ListView.separated(
                          padding:
                              const EdgeInsets.fromLTRB(28, 0, 28, 28),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const _ListDivider(),
                          itemBuilder: (ctx, i) {
                            final track = filtered[i];
                            final isCurrentTrack =
                                currentTrackId == track.id;
                            final ready = track.attributes.status ==
                                TrackStatus.completed;
                            final progress =
                                state.audioProgresses[track.id];
                            return RepaintBoundary(
                              child: _TrackListTile(
                                track: track,
                                isPlaying: isCurrentTrack,
                                isActuallyPlaying:
                                    isCurrentTrack && isActuallyPlaying,
                                progress: progress,
                                onPlay: ready && !isCurrentTrack
                                    ? () => widget.onTrackSelected(track)
                                    : null,
                                onRename: () =>
                                    _showRenameDialog(context, track),
                                onDelete: () =>
                                    _showDeleteDialog(context, track),
                              ),
                            );
                          },
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

// ── Divider ──────────────────────────────────────────────────────────────────

class _ListDivider extends StatelessWidget {
  const _ListDivider();

  @override
  Widget build(BuildContext context) =>
      const ColoredBox(color: AppColors.divider, child: SizedBox(height: 1));
}

// ── Tile ─────────────────────────────────────────────────────────────────────

class _TrackListTile extends StatefulWidget {
  final Track track;
  final bool isPlaying;
  final bool isActuallyPlaying;
  final TrackProgress? progress;
  final VoidCallback? onPlay;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const _TrackListTile({
    required this.track,
    required this.isPlaying,
    required this.isActuallyPlaying,
    required this.progress,
    required this.onPlay,
    required this.onRename,
    required this.onDelete,
  });

  @override
  State<_TrackListTile> createState() => _TrackListTileState();
}

class _TrackListTileState extends State<_TrackListTile> {
  bool _hovered = false;

  String _fmtSeconds(double s) {
    final d = Duration(seconds: s.toInt());
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final ready = widget.track.attributes.status == TrackStatus.completed;
    final canClick = ready && !widget.isPlaying;

    return MouseRegion(
      cursor:
          canClick ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPlay,
        child: ColoredBox(
          color: _hovered ? AppColors.cardHover : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Icon / equalizer
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: widget.isPlaying
                      ? RepaintBoundary(
                          child: _EqualizerBars(
                              playing: widget.isActuallyPlaying),
                        )
                      : Icon(
                          _hovered && ready
                              ? Icons.play_arrow
                              : Icons.music_note,
                          color: _hovered && ready
                              ? AppColors.primary
                              : Colors.white54,
                          size: 20,
                        ),
                ),
                const SizedBox(width: 16),

                // Title + date + progress badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.track.attributes.title,
                        style: TextStyle(
                          color: widget.isPlaying
                              ? AppColors.primary
                              : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            _formatDate(widget.track.attributes.createdAt),
                            style: TextStyle(
                              color: AppColors.onBackground
                                  .withValues(alpha: 0.4),
                              fontSize: 12,
                            ),
                          ),
                          if (widget.progress != null) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.history,
                                size: 12,
                                color: AppColors.primary.withValues(alpha: 0.7)),
                            const SizedBox(width: 3),
                            Text(
                              'Continue · ${_fmtSeconds(widget.progress!.progressSeconds)} / ${_fmtSeconds(widget.progress!.durationSeconds)}',
                              style: TextStyle(
                                color: AppColors.primary.withValues(alpha: 0.7),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Status
                SizedBox(
                  width: 120,
                  child: ready
                      ? const Text('Ready',
                          style:
                              TextStyle(color: Colors.green, fontSize: 13))
                      : const RepaintBoundary(child: _AnimatedDots()),
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
                          color: _hovered
                              ? AppColors.onBackground.withValues(alpha: 0.7)
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
                          color: _hovered
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

// ── Animated dots ─────────────────────────────────────────────────────────────

class _AnimatedDots extends StatefulWidget {
  const _AnimatedDots();

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final dots = '.' * ((_controller.value * 3).floor() + 1);
        return Text(
          'Processing$dots',
          style: const TextStyle(color: Colors.orange, fontSize: 13),
        );
      },
    );
  }
}

// ── Equalizer bars ────────────────────────────────────────────────────────────

class _EqualizerBars extends StatefulWidget {
  final bool playing;
  const _EqualizerBars({required this.playing});

  @override
  State<_EqualizerBars> createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<_EqualizerBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const _phases = [0.0, 0.35, 0.65];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    if (widget.playing) _controller.repeat();
  }

  @override
  void didUpdateWidget(_EqualizerBars old) {
    super.didUpdateWidget(old);
    if (widget.playing && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.playing && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _sin(double x) {
    double v = x % (2 * 3.14159265);
    if (v > 3.14159265) v -= 2 * 3.14159265;
    final x3 = v * v * v;
    final x5 = x3 * v * v;
    final x7 = x5 * v * v;
    return v - x3 / 6 + x5 / 120 - x7 / 5040;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(3, (i) {
            final phase = (_controller.value + _phases[i]) % 1.0;
            final height =
                4.0 + 14.0 * ((1 + _sin(phase * 2 * 3.14159265)) / 2);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                width: 5,
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
