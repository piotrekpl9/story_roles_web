import 'package:story_roles_web/data/models/chapter_response_dto.dart';

abstract class ChapterWebApi {
  Future<List<ChapterResponseDto>> getAll(int projectId);
  Future<ChapterResponseDto> create({
    required int projectId,
    required String name,
    required String content,
  });
  Future<void> rename(int chapterId, String newName);
  Future<void> updateContent(int chapterId, String content);
  Future<void> delete(int chapterId);
  Future<void> generateTracks(int chapterId, String narratorId);
}
