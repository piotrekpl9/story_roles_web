import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/chapter_web_api.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';
import 'package:story_roles_web/domain/repositories/chapter_repository.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final ChapterWebApi chapterWebApi;

  ChapterRepositoryImpl({required this.chapterWebApi});

  @override
  Future<List<Chapter>> getAll(int projectId) async {
    final dtos = await chapterWebApi.getAll(projectId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Result<Chapter>> create({
    required int projectId,
    required String name,
    required String content,
  }) async {
    try {
      final dto = await chapterWebApi.create(
        projectId: projectId,
        name: name,
        content: content,
      );
      return Success(dto.toDomain());
    } catch (_) {
      return Error(const ServerFailure('Failed to create chapter'));
    }
  }

  @override
  Future<Result> rename(int chapterId, String newName) async {
    try {
      await chapterWebApi.rename(chapterId, newName);
      return Success(());
    } catch (_) {
      return Error(const ServerFailure('Failed to rename chapter'));
    }
  }

  @override
  Future<Result> updateContent(int chapterId, String content) async {
    try {
      await chapterWebApi.updateContent(chapterId, content);
      return Success(());
    } catch (_) {
      return Error(const ServerFailure('Failed to update chapter content'));
    }
  }

  @override
  Future<Result> delete(int chapterId) async {
    try {
      await chapterWebApi.delete(chapterId);
      return Success(());
    } catch (_) {
      return Error(const ServerFailure('Failed to delete chapter'));
    }
  }

  @override
  Future<Result> generateTracks(int chapterId, String narratorId) async {
    try {
      await chapterWebApi.generateTracks(chapterId, narratorId);
      return Success(());
    } catch (_) {
      return Error(const ServerFailure('Failed to generate tracks'));
    }
  }
}
