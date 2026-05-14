import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/track_web_api.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/entities/track_progress.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';

class TrackRepositoryImpl implements TrackRepository {
  final TrackWebApi trackWebApi;

  TrackRepositoryImpl({required this.trackWebApi});

  @override
  Future<Result<List<Track>>> getAll({bool forceRefresh = false}) async {
    try {
      final dtos = await trackWebApi.getAll();
      return Success(dtos.map((e) => e.toDomain()).toList());
    } catch (_) {
      return Error(const ServerFailure('Failed to load tracks'));
    }
  }

  @override
  Future<Result<List<Track>>> getByChapter(int chapterId) async {
    try {
      final dtos = await trackWebApi.getByChapter(chapterId);
      return Success(dtos.map((e) => e.toDomain()).toList());
    } catch (_) {
      return Error(const ServerFailure('Failed to load tracks for chapter'));
    }
  }

  @override
  Future<Result<void>> renameTrack(int trackId, String newTitle) async {
    try {
      await trackWebApi.rename(trackId, newTitle);
      return const Success(null);
    } catch (_) {
      return Error(const ServerFailure('Failed to rename track'));
    }
  }

  @override
  Future<Result<void>> deleteTrack(int trackId) async {
    try {
      await trackWebApi.delete(trackId);
      return const Success(null);
    } catch (_) {
      return Error(const ServerFailure('Failed to delete track'));
    }
  }

  @override
  Future<Result<Map<int, TrackProgress>>> getAudioProgresses() async {
    try {
      final progresses = await trackWebApi.getAudioProgresses();
      return Success(progresses);
    } catch (_) {
      return Error(const ServerFailure('Failed to load audio progresses'));
    }
  }

  @override
  Future<Result<List<ScriptWord>>> getScript(int trackId) async {
    try {
      final words = await trackWebApi.getScript(trackId);
      return Success(words);
    } catch (_) {
      return Error(const ServerFailure('Failed to load script'));
    }
  }

  @override
  Future<Result<List<ScriptWord>>> getAlignment(int trackId) async {
    try {
      final words = await trackWebApi.getAlignment(trackId);
      return Success(words);
    } catch (_) {
      return Error(const ServerFailure('Failed to load alignment'));
    }
  }
}
