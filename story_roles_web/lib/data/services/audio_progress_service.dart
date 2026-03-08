import 'dart:async';

import 'package:dio/dio.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';
import 'package:story_roles_web/domain/entities/player_state.dart';

class AudioProgressService {
  final Dio _dio;
  final int _trackId;
  final PlayerState Function() _getPlayerState;
  Timer? _saveTimer;
  bool _disposed = false;

  AudioProgressService({
    required Dio dio,
    required int trackId,
    required PlayerState Function() getPlayerState,
  })  : _dio = dio,
        _trackId = trackId,
        _getPlayerState = getPlayerState {
    _startTimer();
  }

  void _startTimer() {
    _saveTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      saveProgress();
    });
  }

  Future<void> saveProgress() async {
    if (_disposed) return;
    final state = _getPlayerState();
    final durationSeconds = state.duration?.inSeconds ?? 0;
    if (durationSeconds == 0) return;
    try {
      await _dio.post(
        DataConsts.endpoints.saveAudioProgress(_trackId),
        data: {
          'progress_seconds': state.position.inSeconds,
          'duration_seconds': durationSeconds,
        },
      );
    } catch (_) {}
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _saveTimer?.cancel();
    saveProgress();
  }
}
