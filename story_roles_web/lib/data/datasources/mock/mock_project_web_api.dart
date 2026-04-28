import 'package:story_roles_web/data/datasources/abstractions/project_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_data.dart';
import 'package:story_roles_web/data/models/project_response_dto.dart';

class MockProjectWebApi implements ProjectWebApi {
  final List<ProjectResponseDto> _projects = List.of(MockData.projects);
  int _nextId = 100;

  // In a real app the current userId would come from the token.
  // For the mock we default to userId=1 (owner).
  static const _currentUserId = 1;
  static const _companyId = 1;

  @override
  Future<List<ProjectResponseDto>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_projects);
  }

  @override
  Future<ProjectResponseDto> create({required String name}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final project = ProjectResponseDto(
      id: _nextId++,
      companyId: _companyId,
      userId: _currentUserId,
      name: name,
      createdAt: DateTime.now(),
    );
    _projects.add(project);
    return project;
  }

  @override
  Future<void> rename(int projectId, String newName) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index == -1) return;
    final old = _projects[index];
    _projects[index] = ProjectResponseDto(
      id: old.id,
      companyId: old.companyId,
      userId: old.userId,
      name: newName,
      createdAt: old.createdAt,
    );
  }

  @override
  Future<void> delete(int projectId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _projects.removeWhere((p) => p.id == projectId);
  }
}
