import 'dart:typed_data';

import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/chapter_web_api.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/repositories/chapter_repository.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final ChapterWebApi chapterWebApi;

  ChapterRepositoryImpl({required this.chapterWebApi});

  @override
  Future<Result<List<Chapter>>> getAll(int projectId) async {
    try {
      final dtos = await chapterWebApi.getAll(projectId);
      return Success(dtos.map((e) => e.toDomain()).toList());
    } catch (_) {
      return Error(const ServerFailure('Failed to load chapters'));
    }
  }

  @override
  Future<Result<Chapter>> create({
    required int projectId,
    required String name,
    required Uint8List bytes,
    required String fileName,
    required String content,
  }) async {
    try {
      final dto = await chapterWebApi.create(
        projectId: projectId,
        name: name,
        content: content,
        bytes: bytes,
        fileName: fileName,
      );
      return Success(dto.toDomain());
    } catch (_) {
      return Error(const ServerFailure('Failed to create chapter'));
    }
  }

  @override
  Future<Result<void>> rename(int chapterId, String newName) async {
    try {
      await chapterWebApi.rename(chapterId, newName);
      return const Success(null);
    } catch (_) {
      return Error(const ServerFailure('Failed to rename chapter'));
    }
  }

  @override
  Future<Result<void>> updateContent(int chapterId, String content) async {
    try {
      await chapterWebApi.updateContent(chapterId, content);
      return const Success(null);
    } catch (_) {
      return Error(const ServerFailure('Failed to update chapter content'));
    }
  }

  @override
  Future<Result<void>> delete(int chapterId) async {
    try {
      await chapterWebApi.delete(chapterId);
      return const Success(null);
    } catch (_) {
      return Error(const ServerFailure('Failed to delete chapter'));
    }
  }

  @override
  Future<Result<Track>> generateTracks(int projectId, int chapterId, String lectorVoice, String emotion) async {
    try {
      final dto = await chapterWebApi.generateTracks(projectId, chapterId, lectorVoice, emotion);
      return Success(dto.toDomain());
    } catch (_) {
      return Error(const ServerFailure('Failed to generate tracks'));
    }
  }
}
