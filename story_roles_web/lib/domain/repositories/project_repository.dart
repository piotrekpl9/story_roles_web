import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/project.dart';

abstract class ProjectRepository {
  Future<Result<List<Project>>> getAll();
  Future<Result<Project>> getById(int projectId);
  Future<Result<Project>> create({required String name});
  Future<Result<void>> rename(int projectId, String newName);
  Future<Result<void>> delete(int projectId);
}
