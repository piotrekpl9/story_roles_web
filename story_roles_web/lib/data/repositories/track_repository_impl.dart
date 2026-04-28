import 'dart:typed_data';

import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/track_upload_web_api.dart';
import 'package:story_roles_web/data/datasources/abstractions/track_web_api.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/entities/track_progress.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';

class TrackRepositoryImpl implements TrackRepository {
  final TrackWebApi trackWebApi;
  final TrackUploadWebApi trackUploadWebApi;

  TrackRepositoryImpl({
    required this.trackWebApi,
    required this.trackUploadWebApi,
  });

  @override
  Future<List<Track>> getAll({bool forceRefresh = false}) async {
    final dtos = await trackWebApi.getAll();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Track>> getByChapter(int chapterId) async {
    final dtos = await trackWebApi.getByChapter(chapterId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Result> uploadTrack({
    required String title,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      await trackUploadWebApi.upload(
        title: title,
        bytes: bytes,
        fileName: fileName,
      );
      return Success(());
    } catch (e) {
      if (e is ValidationFailure) return Error(e);
      return Error(const ServerFailure('Failed to upload track'));
    }
  }

  @override
  Future<Result> renameTrack(int trackId, String newTitle) async {
    try {
      await trackWebApi.rename(trackId, newTitle);
      return Success(());
    } catch (_) {
      return Error(const ServerFailure('Failed to rename track'));
    }
  }

  @override
  Future<Result> deleteTrack(int trackId) async {
    try {
      await trackWebApi.delete(trackId);
      return Success(());
    } catch (_) {
      return Error(const ServerFailure('Failed to delete track'));
    }
  }

  @override
  Future<Map<int, TrackProgress>> getAudioProgresses() =>
      trackWebApi.getAudioProgresses();

  @override
  Future<List<ScriptWord>> getScript(int trackId) =>
      trackWebApi.getScript(trackId);
}
