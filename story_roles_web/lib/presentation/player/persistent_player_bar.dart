import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/domain/entities/player_state.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc_state.dart';
import 'package:story_roles_web/presentation/player/bloc/player_event.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class PersistentPlayerBar extends StatelessWidget {
  const PersistentPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Reaguje tylko gdy pojawia się/znika track — nie na pozycję
    return BlocBuilder<PlayerBloc, PlayerBlocState>(
      buildWhen: (prev, curr) => prev.hasTrack != curr.hasTrack,
      builder: (context, state) {
        if (!state.hasTrack) return const SizedBox.shrink();
        return const _PlayerBarContent();
      },
    );
  }
}

class _PlayerBarContent extends StatelessWidget {
  const _PlayerBarContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.playerBar,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Row(
        children: [
          Expanded(flex: 3, child: _TrackInfo()),
          Expanded(flex: 5, child: _Controls()),
          Expanded(flex: 3, child: SizedBox()),
        ],
      ),
    );
  }
}

class _TrackInfo extends StatelessWidget {
  const _TrackInfo();

  @override
  Widget build(BuildContext context) {
    // Reaguje tylko na zmianę tracka
    return BlocBuilder<PlayerBloc, PlayerBlocState>(
      buildWhen: (prev, curr) => prev.currentTrack?.id != curr.currentTrack?.id,
      builder: (context, state) {
        final title = state.currentTrack?.attributes.title ?? '';
        return Row(
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
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [_PlaybackButtons(), _Scrubber()],
    );
  }
}

class _PlaybackButtons extends StatelessWidget {
  const _PlaybackButtons();

  @override
  Widget build(BuildContext context) {
    // Reaguje tylko na isLoading i status odtwarzania
    return BlocBuilder<PlayerBloc, PlayerBlocState>(
      buildWhen:
          (prev, curr) =>
              prev.isLoading != curr.isLoading ||
              prev.playerState.status != curr.playerState.status,
      builder: (context, state) {
        final isPlaying = state.playerState.status == PlaybackStatus.playing;
        final isLoading = state.isLoading;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.replay_10),
              color: Colors.white,
              iconSize: 28,
              onPressed:
                  isLoading
                      ? null
                      : () {
                        final pos = state.playerState.position;
                        final np = pos - const Duration(seconds: 10);
                        context.read<PlayerBloc>().add(
                          SeekEvent(np < Duration.zero ? Duration.zero : np),
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
                onPressed:
                    () => context.read<PlayerBloc>().add(TogglePlayEvent()),
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.forward_10),
              color: Colors.white,
              iconSize: 28,
              onPressed:
                  isLoading
                      ? null
                      : () {
                        final dur = state.playerState.duration ?? Duration.zero;
                        final np =
                            state.playerState.position +
                            const Duration(seconds: 10);
                        context.read<PlayerBloc>().add(
                          SeekEvent(np > dur ? dur : np),
                        );
                      },
            ),
          ],
        );
      },
    );
  }
}

class _Scrubber extends StatelessWidget {
  const _Scrubber();

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    // Ten builder reaguje na każdą zmianę pozycji — ale jest izolowany
    return BlocBuilder<PlayerBloc, PlayerBlocState>(
      buildWhen:
          (prev, curr) =>
              prev.playerState.position != curr.playerState.position ||
              prev.playerState.duration != curr.playerState.duration ||
              prev.isLoading != curr.isLoading,
      builder: (context, state) {
        final posMs = state.playerState.position.inMilliseconds.toDouble();
        final durMs =
            state.playerState.duration?.inMilliseconds.toDouble() ?? 0.0;
        final isLoading = state.isLoading;

        return Row(
          children: [
            Text(
              _fmt(state.playerState.position),
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
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: posMs.clamp(0.0, durMs > 0 ? durMs : 1.0),
                  max: durMs > 0 ? durMs : 1.0,
                  onChanged:
                      durMs > 0 && !isLoading
                          ? (v) => context.read<PlayerBloc>().add(
                            SeekEvent(Duration(milliseconds: v.toInt())),
                          )
                          : null,
                ),
              ),
            ),
            Text(
              _fmt(state.playerState.duration ?? Duration.zero),
              style: TextStyle(
                color: AppColors.onBackground.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        );
      },
    );
  }
}
