import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/project_web_api.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectWebApi projectWebApi;

  ProjectRepositoryImpl({required this.projectWebApi});

  @override
  Future<Result<List<Project>>> getAll() async {
    try {
      final dtos = await projectWebApi.getAll();
      return Success(dtos.map((e) => e.toDomain()).toList());
    } catch (_) {
      return Error(const ServerFailure('Failed to load projects'));
    }
  }

  @override
  Future<Result<Project>> getById(int projectId) async {
    try {
      final dto = await projectWebApi.getById(projectId);
      return Success(dto.toDomain());
    } catch (_) {
      return Error(const ServerFailure('Failed to load project'));
    }
  }

  @override
  Future<Result<Project>> create({required String name}) async {
    try {
      final dto = await projectWebApi.create(name: name);
      return Success(dto.toDomain());
    } catch (_) {
      return Error(const ServerFailure('Failed to create project'));
    }
  }

  @override
  Future<Result<void>> rename(int projectId, String newName) async {
    try {
      await projectWebApi.rename(projectId, newName);
      return const Success(null);
    } catch (_) {
      return Error(const ServerFailure('Failed to rename project'));
    }
  }

  @override
  Future<Result<void>> delete(int projectId) async {
    try {
      await projectWebApi.delete(projectId);
      return const Success(null);
    } catch (_) {
      return Error(const ServerFailure('Failed to delete project'));
    }
  }
}
