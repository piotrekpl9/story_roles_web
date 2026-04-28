import 'dart:typed_data';

import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';

abstract class ChapterRepository {
  Future<List<Chapter>> getAll(int projectId);
  Future<Result<Chapter>> create({
    required int projectId,
    required String name,
    required Uint8List bytes,
    required String fileName,
    required String content,
  });
  Future<Result> rename(int chapterId, String newName);
  Future<Result> updateContent(int chapterId, String content);
  Future<Result> delete(int chapterId);
  Future<Result> generateTracks(int projectId, int chapterId, String lectorVoice);
}
