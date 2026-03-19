import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/consts.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';
import 'package:story_roles_web/data/services/audio_progress_service.dart';
import 'package:story_roles_web/domain/entities/player_state.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc_state.dart';
import 'package:story_roles_web/presentation/player/bloc/player_event.dart';
import 'package:story_roles_web/presentation/player/player_controller.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerBlocState> {
  final Dio _dio;
  final StorageDataSource _storageDataSource;

  PlayerController? _controller;
  AudioProgressService? _progressService;

  PlayerBloc({
    required Dio dio,
    required StorageDataSource storageDataSource,
  })  : _dio = dio,
        _storageDataSource = storageDataSource,
        super(const PlayerBlocState()) {
    on<PlayTrackEvent>(_onPlayTrack);
    on<TogglePlayEvent>(_onTogglePlay);
    on<SeekEvent>(_onSeek);
    on<PlayerStateUpdated>(_onPlayerStateUpdated);
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

    _progressService?.dispose();
    _progressService = null;
    _controller?.dispose();
    _controller = PlayerController();
    _controller!.stateNotifier.addListener(() => add(PlayerStateUpdated()));

    try {
      final token = await _storageDataSource.readToken() ?? '';
      final audioUrl =
          '${CoreConsts.baseUrl}api/v1/tracks/${event.track.id}/file';

      final response = await _dio.get<List<int>>(
        audioUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      final bytes = Uint8List.fromList(response.data!);
      await _controller!.loadFromBytes(bytes);
      await _controller!.play();

      _progressService = AudioProgressService(
        dio: _dio,
        trackId: event.track.id,
        getPlayerState: () => _currentPlayerState,
      );

      emit(state.copyWith(isLoading: false));
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

  void _onPlayerStateUpdated(
    PlayerStateUpdated event,
    Emitter<PlayerBlocState> emit,
  ) {
    emit(state.copyWith(playerState: _currentPlayerState));
  }

  @override
  Future<void> close() {
    _progressService?.dispose();
    _controller?.dispose();
    return super.close();
  }
}
