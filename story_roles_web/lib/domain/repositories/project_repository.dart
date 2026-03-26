import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getAll();
  Future<Project> create({required String name});
  Future<Result> rename(int projectId, String newName);
  Future<Result> delete(int projectId);
}
