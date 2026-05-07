import 'dart:async';

import 'package:story_roles_web/domain/entities/player_state.dart';
import 'package:story_roles_web/domain/repositories/track_audio_source.dart';

class AudioProgressService {
  final TrackAudioSource _audioSource;
  final int _trackId;
  final PlayerState Function() _getPlayerState;
  Timer? _saveTimer;
  bool _disposed = false;

  AudioProgressService({
    required TrackAudioSource audioSource,
    required int trackId,
    required PlayerState Function() getPlayerState,
  })  : _audioSource = audioSource,
        _trackId = trackId,
        _getPlayerState = getPlayerState {
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
      await _audioSource.saveProgress(
        _trackId,
        state.position.inSeconds,
        durationSeconds,
      );
    } catch (_) {}
  }

  Future<void> resetProgress() async {
    if (_disposed) return;
    final durationSeconds = _getPlayerState().duration?.inSeconds ?? 0;
    try {
      await _audioSource.resetProgress(_trackId, durationSeconds);
    } catch (_) {}
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _saveTimer?.cancel();
    await saveProgress();
  }
}
