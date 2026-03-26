import 'package:story_roles_web/data/models/project_response_dto.dart';

abstract class ProjectWebApi {
  Future<List<ProjectResponseDto>> getAll();
  Future<ProjectResponseDto> create({required String name});
  Future<void> rename(int projectId, String newName);
  Future<void> delete(int projectId);
}
