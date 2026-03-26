import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/project_web_api.dart';
import 'package:story_roles_web/data/models/project_response_dto.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';

class ProjectWebApiImpl implements ProjectWebApi {
  final Dio dio;

  ProjectWebApiImpl({required this.dio});

  @override
  Future<List<ProjectResponseDto>> getAll() async {
    final response = await dio.get(DataConsts.endpoints.getProjects);
    return (response.data['data']['projects'] as List?)
            ?.map((e) => ProjectResponseDto.fromJson(e))
            .toList() ??
        [];
  }

  @override
  Future<ProjectResponseDto> create({required String name}) async {
    final response = await dio.post(
      DataConsts.endpoints.getProjects,
      data: {'name': name},
    );
    return ProjectResponseDto.fromJson(response.data['data']['project']);
  }

  @override
  Future<void> rename(int projectId, String newName) async {
    await dio.patch(
      DataConsts.endpoints.projectById(projectId),
      data: {'name': newName},
    );
  }

  @override
  Future<void> delete(int projectId) async {
    await dio.delete(DataConsts.endpoints.projectById(projectId));
  }
}
