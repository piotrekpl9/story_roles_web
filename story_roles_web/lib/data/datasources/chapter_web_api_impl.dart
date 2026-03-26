import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/chapter_web_api.dart';
import 'package:story_roles_web/data/models/chapter_response_dto.dart';

// Chapters endpoint not yet implemented – data is hardcoded until backend is ready
class ChapterWebApiImpl implements ChapterWebApi {
  final Dio dio;

  ChapterWebApiImpl({required this.dio});

  final List<Map<String, dynamic>> _mockChapters = [
    {
      'id': 1,
      'project_id': 1,
      'name': 'Ziarno prawdy',
      'content': 'Geralt wjechał do wioski o zmierzchu. Powietrze pachniało dymem i strachem.',
      'created_at': '2024-01-06T10:00:00.000Z',
    },
    {
      'id': 2,
      'project_id': 1,
      'name': 'Mniejsze zło',
      'content': 'Wybór między złem a złem – wiedźmin znał te dylematy zbyt dobrze.',
      'created_at': '2024-01-07T10:00:00.000Z',
    },
    {
      'id': 3,
      'project_id': 2,
      'name': 'Pierwszy kontakt',
      'content': 'Statek Prometeusz zbliżał się do planety Solaris.',
      'created_at': '2024-02-02T08:00:00.000Z',
    },
    {
      'id': 4,
      'project_id': 3,
      'name': 'Inwokacja',
      'content': 'Litwo! Ojczyzno moja! ty jesteś jak zdrowie.',
      'created_at': '2024-03-11T09:00:00.000Z',
    },
  ];

  int _nextId = 10;

  @override
  Future<List<ChapterResponseDto>> getAll(int projectId) async {
    return _mockChapters
        .where((c) => c['project_id'] == projectId)
        .map(ChapterResponseDto.fromJson)
        .toList();
  }

  @override
  Future<ChapterResponseDto> create({
    required int projectId,
    required String name,
    required String content,
  }) async {
    final data = {
      'id': _nextId++,
      'project_id': projectId,
      'name': name,
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    };
    _mockChapters.add(data);
    return ChapterResponseDto.fromJson(data);
  }

  @override
  Future<void> rename(int chapterId, String newName) async {
    final idx = _mockChapters.indexWhere((c) => c['id'] == chapterId);
    if (idx != -1) _mockChapters[idx] = {..._mockChapters[idx], 'name': newName};
  }

  @override
  Future<void> updateContent(int chapterId, String content) async {
    final idx = _mockChapters.indexWhere((c) => c['id'] == chapterId);
    if (idx != -1) _mockChapters[idx] = {..._mockChapters[idx], 'content': content};
  }

  @override
  Future<void> delete(int chapterId) async {
    _mockChapters.removeWhere((c) => c['id'] == chapterId);
  }

  @override
  Future<void> generateTracks(int chapterId, String narratorId) async {
    // no-op until backend endpoint is ready
  }
}
