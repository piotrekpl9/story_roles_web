import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/project_web_api.dart';
import 'package:story_roles_web/data/models/project_response_dto.dart';

// TODO: replace hardcoded data with real endpoints when backend is ready
class ProjectWebApiImpl implements ProjectWebApi {
  final Dio dio;

  ProjectWebApiImpl({required this.dio});

  final List<Map<String, dynamic>> _mockProjects = [
    {
      'id': 1,
      'company_id': 1,
      'user_id': 1,
      'name': 'Wiedźmin – Ostatnie życzenie',
      'created_at': '2024-01-05T00:00:00.000Z',
    },
    {
      'id': 2,
      'company_id': 1,
      'user_id': 1,
      'name': 'Solaris',
      'created_at': '2024-02-01T00:00:00.000Z',
    },
    {
      'id': 3,
      'company_id': 1,
      'user_id': 2,
      'name': 'Pan Tadeusz',
      'created_at': '2024-03-10T00:00:00.000Z',
    },
    {
      'id': 4,
      'company_id': 1,
      'user_id': 3,
      'name': 'Lalka',
      'created_at': '2024-03-15T00:00:00.000Z',
    },
  ];

  int _nextId = 10;

  @override
  Future<List<ProjectResponseDto>> getAll() async {
    return _mockProjects.map(ProjectResponseDto.fromJson).toList();
  }

  @override
  Future<ProjectResponseDto> create({required String name}) async {
    final data = {
      'id': _nextId++,
      'company_id': 1,
      'user_id': 1,
      'name': name,
      'created_at': DateTime.now().toIso8601String(),
    };
    _mockProjects.add(data);
    return ProjectResponseDto.fromJson(data);
  }

  @override
  Future<void> rename(int projectId, String newName) async {
    final idx = _mockProjects.indexWhere((p) => p['id'] == projectId);
    if (idx != -1) _mockProjects[idx] = {..._mockProjects[idx], 'name': newName};
  }

  @override
  Future<void> delete(int projectId) async {
    _mockProjects.removeWhere((p) => p['id'] == projectId);
  }
}
