import 'dart:typed_data';

abstract class TrackAudioSource {
  Future<Uint8List> fetchAudio(int trackId);
  Future<Duration> fetchSavedProgress(int trackId);
  Future<void> saveProgress(int trackId, int progressSeconds, int durationSeconds);
  Future<void> resetProgress(int trackId, int durationSeconds);
}
