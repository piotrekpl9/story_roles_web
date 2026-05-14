import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/services/audio_progress_service.dart';
import 'package:story_roles_web/domain/entities/player_state.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';
import 'package:story_roles_web/domain/repositories/track_audio_source.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc_state.dart';
import 'package:story_roles_web/presentation/player/bloc/player_event.dart';
import 'package:story_roles_web/presentation/player/player_controller.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerBlocState> {
  final TrackAudioSource _audioSource;
  final TrackRepository _trackRepository;

  PlayerController? _controller;
  AudioProgressService? _progressService;

  PlayerBloc({
    required TrackAudioSource audioSource,
    required TrackRepository trackRepository,
  })  : _audioSource = audioSource,
        _trackRepository = trackRepository,
        super(const PlayerBlocState()) {
    on<PlayTrackEvent>(_onPlayTrack);
    on<TogglePlayEvent>(_onTogglePlay);
    on<SeekEvent>(_onSeek);
    on<PlayerStateUpdated>(_onPlayerStateUpdated);
    on<ClosePlayerEvent>(_onClosePlayer);
  }

  PlayerState get _currentPlayerState =>
      _controller?.currentState ?? const PlayerState.initial();

  Future<void> _onPlayTrack(
    PlayTrackEvent event,
    Emitter<PlayerBlocState> emit,
  ) async {
    emit(state.copyWith(
      currentTrack: event.track,
      isLoading: true,
      clearError: true,
      playerState: const PlayerState.initial(),
    ));

    await _progressService?.dispose();
    _progressService = null;
    _controller?.dispose();
    _controller = PlayerController();
    _controller!.stateNotifier.addListener(() => add(PlayerStateUpdated()));

    try {
      final bytes = await _audioSource.fetchAudio(event.track.id);
      await _controller!.loadFromBytes(bytes);

      final savedPosition = await _audioSource.fetchSavedProgress(event.track.id);
      if (savedPosition > Duration.zero) {
        await _controller!.seek(savedPosition);
      }

      await _controller!.play();

      _progressService = AudioProgressService(
        audioSource: _audioSource,
        trackId: event.track.id,
        getPlayerState: () => _currentPlayerState,
      );

      final scriptResult = await _trackRepository.getScript(event.track.id);
      List<ScriptWord>? script = scriptResult.dataOrNull;

      if (script == null || script.isEmpty) {
        final alignmentResult =
            await _trackRepository.getAlignment(event.track.id);
        script = alignmentResult.dataOrNull;
      }

      emit(state.copyWith(isLoading: false, script: script));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load audio. Please try again.',
      ));
    }
  }

  Future<void> _onTogglePlay(
    TogglePlayEvent event,
    Emitter<PlayerBlocState> emit,
  ) async {
    final playerState = _currentPlayerState;
    if (playerState.status == PlaybackStatus.playing) {
      await _controller?.pause();
      _progressService?.saveProgress();
    } else {
      if (playerState.duration != null &&
          playerState.position >= playerState.duration!) {
        await _controller?.seek(Duration.zero);
      }
      await _controller?.play();
      _progressService?.saveProgress();
    }
  }

  Future<void> _onSeek(
    SeekEvent event,
    Emitter<PlayerBlocState> emit,
  ) async {
    await _controller?.seek(event.position);
    _progressService?.saveProgress();
  }

  Future<void> _onClosePlayer(
    ClosePlayerEvent event,
    Emitter<PlayerBlocState> emit,
  ) async {
    await _progressService?.dispose();
    _progressService = null;
    _controller?.dispose();
    _controller = null;
    emit(state.copyWith(clearTrack: true, playerState: const PlayerState.initial()));
  }

  void _onPlayerStateUpdated(
    PlayerStateUpdated event,
    Emitter<PlayerBlocState> emit,
  ) {
    final playerState = _currentPlayerState;
    if (playerState.status == PlaybackStatus.completed) {
      _progressService?.resetProgress();
    }
    emit(state.copyWith(playerState: playerState));
  }

  @override
  Future<void> close() {
    _progressService?.dispose();
    _controller?.dispose();
    return super.close();
  }
}
