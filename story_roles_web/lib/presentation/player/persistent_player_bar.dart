import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_roles_web/domain/entities/player_state.dart';
import 'package:story_roles_web/presentation/player/player_manager.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class PersistentPlayerBar extends StatelessWidget {
  const PersistentPlayerBar({super.key});

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerManager>(
      builder: (context, manager, _) {
        if (!manager.hasTrack) return const SizedBox.shrink();

        final track = manager.currentTrack!;
        final state = manager.playerState;
        final isPlaying = state.status == PlaybackStatus.playing;
        final isLoading = manager.isLoading;

        final posMs = state.position.inMilliseconds.toDouble();
        final durMs = state.duration?.inMilliseconds.toDouble() ?? 0.0;

        return Container(
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.playerBar,
            border: Border(
              top: BorderSide(color: AppColors.divider),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Art + title (left)
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                          colors: [Colors.purple[300]!, Colors.blue[300]!],
                        ),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Flexible(
                      child: Text(
                        track.attributes.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Controls + progress (center)
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          color: Colors.white,
                          iconSize: 28,
                          onPressed: isLoading
                              ? null
                              : () {
                                  final np = state.position -
                                      const Duration(seconds: 10);
                                  manager.seek(
                                    np < Duration.zero ? Duration.zero : np,
                                  );
                                },
                        ),
                        const SizedBox(width: 8),
                        if (isLoading)
                          const SizedBox(
                            width: 44,
                            height: 44,
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF8A5B),
                              strokeWidth: 2.5,
                            ),
                          )
                        else
                          IconButton(
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                            ),
                            iconSize: 44,
                            color: AppColors.primary,
                            onPressed: manager.togglePlay,
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          color: Colors.white,
                          iconSize: 28,
                          onPressed: isLoading
                              ? null
                              : () {
                                  final dur =
                                      state.duration ?? Duration.zero;
                                  final np = state.position +
                                      const Duration(seconds: 10);
                                  manager.seek(np > dur ? dur : np);
                                },
                        ),
                      ],
                    ),

                    // Scrubber
                    Row(
                      children: [
                        Text(
                          _fmt(state.position),
                          style: TextStyle(
                            color: AppColors.onBackground.withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 5,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 10,
                              ),
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor:
                                  Colors.white.withValues(alpha: 0.25),
                              thumbColor: AppColors.primary,
                              overlayColor:
                                  AppColors.primary.withValues(alpha: 0.2),
                            ),
                            child: Slider(
                              value: posMs.clamp(
                                0.0,
                                durMs > 0 ? durMs : 1.0,
                              ),
                              max: durMs > 0 ? durMs : 1.0,
                              onChanged: durMs > 0 && !isLoading
                                  ? (v) => manager.seek(
                                        Duration(milliseconds: v.toInt()),
                                      )
                                  : null,
                            ),
                          ),
                        ),
                        Text(
                          _fmt(state.duration ?? Duration.zero),
                          style: TextStyle(
                            color: AppColors.onBackground.withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Expanded(flex: 3, child: SizedBox()),
            ],
          ),
        );
      },
    );
  }
}
