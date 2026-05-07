import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:story_roles_web/core/consts.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';
import 'package:story_roles_web/domain/repositories/track_audio_source.dart';

class HttpTrackAudioSource implements TrackAudioSource {
  final Dio _dio;

  HttpTrackAudioSource({required Dio dio}) : _dio = dio;

  @override
  Future<Uint8List> fetchAudio(int trackId) async {
    final audioUrl = '${CoreConsts.baseUrl}api/v1/tracks/$trackId/file';
    final response = await _dio.get<List<int>>(
      audioUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  @override
  Future<Duration> fetchSavedProgress(int trackId) async {
    try {
      final response = await _dio.get(
        DataConsts.endpoints.getAudioProgress(trackId),
      );
      final seconds = response
          .data?['data']?['audio_progress']?['attributes']?['progress_seconds'] as num?;
      if (seconds != null && seconds > 0) {
        return Duration(seconds: seconds.toInt());
      }
    } catch (_) {}
    return Duration.zero;
  }

  @override
  Future<void> saveProgress(
    int trackId,
    int progressSeconds,
    int durationSeconds,
  ) async {
    await _dio.post(
      DataConsts.endpoints.saveAudioProgress(trackId),
      data: {
        'progress_seconds': progressSeconds,
        'duration_seconds': durationSeconds,
      },
    );
  }

  @override
  Future<void> resetProgress(int trackId, int durationSeconds) async {
    await _dio.post(
      DataConsts.endpoints.saveAudioProgress(trackId),
      data: {'progress_seconds': 0, 'duration_seconds': durationSeconds},
    );
  }
}
