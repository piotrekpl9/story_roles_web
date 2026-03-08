import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/core/consts.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';
import 'package:story_roles_web/data/services/audio_progress_service.dart';
import 'package:story_roles_web/domain/entities/player_state.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/presentation/player/player_controller.dart';

class PlayerManager extends ChangeNotifier {
  final Dio _dio;
  final StorageDataSource _storageDataSource;

  PlayerController? _controller;
  AudioProgressService? _progressService;
  Track? _currentTrack;
  bool _isLoading = false;
  String? _error;

  PlayerManager({
    required Dio dio,
    required StorageDataSource storageDataSource,
  })  : _dio = dio,
        _storageDataSource = storageDataSource;

  Track? get currentTrack => _currentTrack;
  PlayerController? get controller => _controller;
  bool get isLoading => _isLoading;
  bool get hasTrack => _currentTrack != null;
  String? get error => _error;

  PlayerState get playerState =>
      _controller?.currentState ?? const PlayerState.initial();

  Future<void> playTrack(Track track) async {
    _currentTrack = track;
    _isLoading = true;
    _error = null;
    notifyListeners();

    _progressService?.dispose();
    _progressService = null;
    _controller?.dispose();
    _controller = PlayerController();
    _controller!.stateNotifier.addListener(notifyListeners);

    try {
      final token = await _storageDataSource.readToken() ?? '';
      final audioUrl = '${CoreConsts.baseUrl}api/v1/tracks/${track.id}/file';

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
        trackId: track.id,
        getPlayerState: () => playerState,
      );
    } catch (e) {
      _error = 'Failed to load audio. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> togglePlay() async {
    final state = playerState;
    if (state.status == PlaybackStatus.playing) {
      await _controller?.pause();
      _progressService?.saveProgress();
    } else {
      if (state.duration != null && state.position >= state.duration!) {
        await _controller?.seek(Duration.zero);
      }
      await _controller?.play();
      _progressService?.saveProgress();
    }
  }

  Future<void> seek(Duration position) async {
    await _controller?.seek(position);
    _progressService?.saveProgress();
  }

  @override
  void dispose() {
    _progressService?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
