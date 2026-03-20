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
    final progressSeconds = state.position.inSeconds;
    print('[AudioProgress] saveProgress trackId=$_trackId progress=${progressSeconds}s duration=${durationSeconds}s');
    try {
      final response = await _dio.post(
        DataConsts.endpoints.saveAudioProgress(_trackId),
        data: {
          'progress_seconds': progressSeconds,
          'duration_seconds': durationSeconds,
        },
      );
      print('[AudioProgress] saveProgress response: ${response.statusCode} ${response.data}');
    } catch (e) {
      print('[AudioProgress] saveProgress error: $e');
    }
  }

  Future<void> resetProgress() async {
    if (_disposed) return;
    final durationSeconds = _getPlayerState().duration?.inSeconds ?? 0;
    print('[AudioProgress] resetProgress trackId=$_trackId duration=${durationSeconds}s');
    try {
      final response = await _dio.post(
        DataConsts.endpoints.saveAudioProgress(_trackId),
        data: {
          'progress_seconds': 0,
          'duration_seconds': durationSeconds,
        },
      );
      print('[AudioProgress] resetProgress response: ${response.statusCode} ${response.data}');
    } catch (e) {
      print('[AudioProgress] resetProgress error: $e');
    }
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _saveTimer?.cancel();
    saveProgress();
  }
}
