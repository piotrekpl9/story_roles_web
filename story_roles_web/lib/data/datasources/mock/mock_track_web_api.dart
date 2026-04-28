import 'package:story_roles_web/data/datasources/abstractions/track_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_data.dart';
import 'package:story_roles_web/data/models/attributes_response_dto.dart';
import 'package:story_roles_web/data/models/track_response_dto.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';
import 'package:story_roles_web/domain/entities/track_progress.dart';

class MockTrackWebApi implements TrackWebApi {
  final List<TrackResponseDto> _tracks = List.of(MockData.tracks);
  final Map<int, TrackProgress> _progresses = {};
  int _nextId = 200;

  @override
  Future<List<TrackResponseDto>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_tracks);
  }

  @override
  Future<List<TrackResponseDto>> getByChapter(int chapterId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _tracks.where((t) => t.chapterId == chapterId).toList();
  }

  @override
  Future<void> rename(int trackId, String newTitle) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _tracks.indexWhere((t) => t.id == trackId);
    if (index == -1) return;
    final old = _tracks[index];
    _tracks[index] = TrackResponseDto(
      id: old.id,
      chapterId: old.chapterId,
      attributesResponseDto: old.attributesResponseDto.copyWith(title: newTitle),
    );
  }

  @override
  Future<void> delete(int trackId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tracks.removeWhere((t) => t.id == trackId);
    _progresses.remove(trackId);
  }

  @override
  Future<Map<int, TrackProgress>> getAudioProgresses() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return Map.unmodifiable(_progresses);
  }

  @override
  Future<List<ScriptWord>> getScript(int trackId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final words = MockData.scriptWords[trackId];
    if (words == null) return const [];
    return words;
  }

  /// Called by [MockChapterWebApi] when generation is triggered.
  /// Adds a pending track for the chapter, then marks it completed after 4s.
  void addPendingTracksForChapter(int chapterId, String chapterName, String narratorId) {
    final id = _nextId++;

    _tracks.add(TrackResponseDto(
      id: id,
      chapterId: chapterId,
      attributesResponseDto: AttributesResponseDto(
        title: '$chapterName – $narratorId',
        imageUrl: null,
        createdAt: DateTime.now(),
        status: 'pending',
      ),
    ));

    // Simulate async generation completing after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      final index = _tracks.indexWhere((t) => t.id == id);
      if (index == -1) return;
      final old = _tracks[index];
      _tracks[index] = TrackResponseDto(
        id: old.id,
        chapterId: old.chapterId,
        attributesResponseDto: AttributesResponseDto(
          title: old.attributesResponseDto.title,
          imageUrl: null,
          createdAt: old.attributesResponseDto.createdAt,
          status: 'completed',
        ),
      );
    });
  }
}
