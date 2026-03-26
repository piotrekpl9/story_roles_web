import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/chapter_web_api.dart';
import 'package:story_roles_web/data/models/chapter_response_dto.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';

class ChapterWebApiImpl implements ChapterWebApi {
  final Dio dio;

  ChapterWebApiImpl({required this.dio});

  @override
  Future<List<ChapterResponseDto>> getAll(int projectId) async {
    final response = await dio.get(DataConsts.endpoints.getChapters(projectId));
    return (response.data['data']['chapters'] as List?)
            ?.map((e) => ChapterResponseDto.fromJson(e))
            .toList() ??
        [];
  }

  @override
  Future<ChapterResponseDto> create({
    required int projectId,
    required String name,
    required String content,
  }) async {
    final response = await dio.post(
      DataConsts.endpoints.getChapters(projectId),
      data: {'name': name, 'content': content},
    );
    final attrs = response.data['data']['chapter'];
    return ChapterResponseDto.fromJson(attrs);
  }

  @override
  Future<void> rename(int chapterId, String newName) async {
    await dio.patch(
      DataConsts.endpoints.chapterById(chapterId),
      data: {'name': newName},
    );
  }

  @override
  Future<void> updateContent(int chapterId, String content) async {
    await dio.patch(
      DataConsts.endpoints.chapterById(chapterId),
      data: {'content': content},
    );
  }

  @override
  Future<void> delete(int chapterId) async {
    await dio.delete(DataConsts.endpoints.chapterById(chapterId));
  }

  @override
  Future<void> generateTracks(int chapterId, String narratorId) async {
    await dio.post(
      DataConsts.endpoints.generateChapterTracks(chapterId),
      data: {'narrator_id': narratorId},
    );
  }
}
