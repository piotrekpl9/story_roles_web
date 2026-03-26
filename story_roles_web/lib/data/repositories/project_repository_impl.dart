import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/project_web_api.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectWebApi projectWebApi;

  ProjectRepositoryImpl({required this.projectWebApi});

  @override
  Future<List<Project>> getAll() async {
    final dtos = await projectWebApi.getAll();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Project> create({required String name}) async {
    final dto = await projectWebApi.create(name: name);
    return dto.toDomain();
  }

  @override
  Future<Result> rename(int projectId, String newName) async {
    try {
      await projectWebApi.rename(projectId, newName);
      return Success(());
    } catch (_) {
      return Error(const ServerFailure('Failed to rename project'));
    }
  }

  @override
  Future<Result> delete(int projectId) async {
    try {
      await projectWebApi.delete(projectId);
      return Success(());
    } catch (_) {
      return Error(const ServerFailure('Failed to delete project'));
    }
  }
}
