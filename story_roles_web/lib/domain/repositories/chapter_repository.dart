import 'dart:typed_data';

import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';
import 'package:story_roles_web/domain/entities/track.dart';

abstract class ChapterRepository {
  Future<Result<List<Chapter>>> getAll(int projectId);
  Future<Result<Chapter>> create({
    required int projectId,
    required String name,
    required Uint8List bytes,
    required String fileName,
    required String content,
  });
  Future<Result<void>> rename(int chapterId, String newName);
  Future<Result<void>> updateContent(int chapterId, String content);
  Future<Result<void>> delete(int chapterId);
  Future<Result<Track>> generateTracks(int projectId, int chapterId, String lectorVoice, String emotion);
}
