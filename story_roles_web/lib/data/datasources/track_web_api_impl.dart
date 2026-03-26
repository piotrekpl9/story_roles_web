import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/track_web_api.dart';
import 'package:story_roles_web/data/models/track_response_dto.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';
import 'package:story_roles_web/domain/entities/track_progress.dart';

class TrackWebApiImpl implements TrackWebApi {
  final Dio dio;

  TrackWebApiImpl({required this.dio});

  @override
  Future<List<TrackResponseDto>> getAll() async {
    final response = await dio.get(DataConsts.endpoints.getTracks);
    return (response.data["data"]["tracks"] as List?)
            ?.map((e) => TrackResponseDto.fromJson(e))
            .toList() ??
        [];
  }

  @override
  Future<List<TrackResponseDto>> getByChapter(int chapterId) async {
    // TODO: replace with real endpoint when backend supports it
    final all = await getAll();
    return all.where((t) => t.chapterId == chapterId).toList();
  }

  @override
  Future<void> rename(int trackId, String newTitle) async {
    await dio.patch(
      DataConsts.endpoints.renameTrack(trackId),
      data: {
        'track': {'title': newTitle},
      },
    );
  }

  @override
  Future<void> delete(int trackId) async {
    await dio.delete(DataConsts.endpoints.deleteTrack(trackId));
  }

  @override
  Future<Map<int, TrackProgress>> getAudioProgresses() async {
    final response = await dio.get(DataConsts.endpoints.getAudioProgresses);
    final list = response.data['data']['audio_progresses'] as List? ?? [];
    final result = <int, TrackProgress>{};
    for (final e in list) {
      final attrs = e['attributes'] as Map<String, dynamic>?;
      if (attrs == null) continue;
      final progress = (attrs['progress_seconds'] as num?)?.toDouble() ?? 0;
      if (progress <= 0) continue;
      final trackId = (attrs['track_id'] as num).toInt();
      result[trackId] = TrackProgress(
        trackId: trackId,
        progressSeconds: progress,
        durationSeconds: (attrs['duration_seconds'] as num?)?.toDouble() ?? 0,
      );
    }
    return result;
  }
}
