import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:story_roles_web/core/error/failures.dart';
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
    required Uint8List bytes,
    required String fileName,
    required String content,
  }) async {
    final formData = FormData();
    formData.fields.add(MapEntry('name', name));
    formData.fields.add(MapEntry('content', content));
    formData.files.add(
      MapEntry('file', MultipartFile.fromBytes(bytes, filename: fileName)),
    );

    final response = await dio.post(
      DataConsts.endpoints.getChapters(projectId),
      data: formData,
      options: Options(validateStatus: (status) => status! < 500),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final errorMessage =
          response.data['status']?['message'] ?? 'Create failed';
      throw ValidationFailure(errorMessage);
    }

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
  Future<void> generateTracks(int projectId, int chapterId, String lectorVoice) async {
    await dio.post(
      DataConsts.endpoints.generateChapterTracks(projectId, chapterId),
      data: {'lector_voice': lectorVoice},
    );
  }
}
