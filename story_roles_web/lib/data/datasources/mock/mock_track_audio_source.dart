import 'package:flutter/services.dart';
import 'package:story_roles_web/domain/repositories/track_audio_source.dart';

class MockTrackAudioSource implements TrackAudioSource {
  @override
  Future<Uint8List> fetchAudio(int trackId) async {
    final data = await rootBundle.load('assets/audio/mock_sample.wav');
    return data.buffer.asUint8List();
  }

  @override
  Future<Duration> fetchSavedProgress(int trackId) async => Duration.zero;

  @override
  Future<void> saveProgress(
    int trackId,
    int progressSeconds,
    int durationSeconds,
  ) async {}

  @override
  Future<void> resetProgress(int trackId, int durationSeconds) async {}
}
