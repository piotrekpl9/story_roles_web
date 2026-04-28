import 'dart:typed_data';

import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/entities/track_progress.dart';

abstract class TrackRepository {
  Future<List<Track>> getAll({bool forceRefresh = false});
  Future<List<Track>> getByChapter(int chapterId);
  Future<Result> uploadTrack({
    required String title,
    required Uint8List bytes,
    required String fileName,
  });
  Future<Result> renameTrack(int trackId, String newTitle);
  Future<Result> deleteTrack(int trackId);
  Future<Map<int, TrackProgress>> getAudioProgresses();
  Future<List<ScriptWord>> getScript(int trackId);
}
