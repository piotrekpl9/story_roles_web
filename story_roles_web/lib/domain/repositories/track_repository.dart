import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/entities/track_progress.dart';

abstract class TrackRepository {
  Future<Result<List<Track>>> getAll({bool forceRefresh = false});
  Future<Result<List<Track>>> getByChapter(int chapterId);
  Future<Result<void>> renameTrack(int trackId, String newTitle);
  Future<Result<void>> deleteTrack(int trackId);
  Future<Result<Map<int, TrackProgress>>> getAudioProgresses();
  Future<Result<List<ScriptWord>>> getScript(int trackId);
  Future<Result<List<ScriptWord>>> getAlignment(int trackId);
}
