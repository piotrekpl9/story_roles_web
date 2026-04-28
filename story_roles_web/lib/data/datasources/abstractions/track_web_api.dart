import 'package:story_roles_web/data/models/track_response_dto.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';
import 'package:story_roles_web/domain/entities/track_progress.dart';

abstract class TrackWebApi {
  Future<List<TrackResponseDto>> getAll();
  Future<List<TrackResponseDto>> getByChapter(int chapterId);
  Future<void> rename(int trackId, String newTitle);
  Future<void> delete(int trackId);
  Future<Map<int, TrackProgress>> getAudioProgresses();
  Future<List<ScriptWord>> getScript(int trackId);
}
