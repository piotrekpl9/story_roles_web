import 'dart:typed_data';

import 'package:story_roles_web/data/datasources/abstractions/chapter_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_data.dart';
import 'package:story_roles_web/data/datasources/mock/mock_track_web_api.dart';
import 'package:story_roles_web/data/models/chapter_response_dto.dart';

class MockChapterWebApi implements ChapterWebApi {
  final MockTrackWebApi _trackWebApi;
  final List<ChapterResponseDto> _chapters = List.of(MockData.chapters);
  int _nextId = 100;

  MockChapterWebApi({required MockTrackWebApi trackWebApi})
      : _trackWebApi = trackWebApi;

  @override
  Future<List<ChapterResponseDto>> getAll(int projectId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _chapters.where((c) => c.projectId == projectId).toList();
  }

  @override
  Future<ChapterResponseDto> create({
    required int projectId,
    required String name,
    required String content,
    required Uint8List bytes,
    required String fileName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final chapter = ChapterResponseDto(
      id: _nextId++,
      projectId: projectId,
      name: name,
      content: content,
      createdAt: DateTime.now(),
    );
    _chapters.add(chapter);
    return chapter;
  }

  @override
  Future<void> rename(int chapterId, String newName) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _chapters.indexWhere((c) => c.id == chapterId);
    if (index == -1) return;
    final old = _chapters[index];
    _chapters[index] = ChapterResponseDto(
      id: old.id,
      projectId: old.projectId,
      name: newName,
      content: old.content,
      createdAt: old.createdAt,
    );
  }

  @override
  Future<void> updateContent(int chapterId, String content) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _chapters.indexWhere((c) => c.id == chapterId);
    if (index == -1) return;
    final old = _chapters[index];
    _chapters[index] = ChapterResponseDto(
      id: old.id,
      projectId: old.projectId,
      name: old.name,
      content: content,
      createdAt: old.createdAt,
    );
  }

  @override
  Future<void> delete(int chapterId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _chapters.removeWhere((c) => c.id == chapterId);
  }

  @override
  Future<void> generateTracks(int projectId, int chapterId, String lectorVoice) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final chapter = _chapters.firstWhere((c) => c.id == chapterId);
    _trackWebApi.addPendingTracksForChapter(chapterId, chapter.name, lectorVoice);
  }
}
