import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/company_web_api.dart';
import 'package:story_roles_web/data/models/company_response_dto.dart';
import 'package:story_roles_web/data/models/user_response_dto.dart';

// Company/users endpoints not yet implemented – data is hardcoded until backend is ready
class CompanyWebApiImpl implements CompanyWebApi {
  final Dio dio;

  CompanyWebApiImpl({required this.dio});

  final Map<String, dynamic> _mockCompany = {
    'id': 1,
    'name': 'Helion S.A.',
    'allowed_users': 10,
    'active': true,
    'created_at': '2023-06-01T00:00:00.000Z',
  };

  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 1,
      'role': 1,
      'company_id': 1,
      'username': 'Anna Kowalska',
      'email': 'anna.kowalska@helion.pl',
      'active': true,
      'created_at': '2023-06-01T00:00:00.000Z',
    },
    {
      'id': 2,
      'role': 2,
      'company_id': 1,
      'username': 'Marek Nowak',
      'email': 'marek.nowak@helion.pl',
      'active': true,
      'created_at': '2023-07-15T00:00:00.000Z',
    },
    {
      'id': 3,
      'role': 2,
      'company_id': 1,
      'username': 'Katarzyna Wiśniewska',
      'email': 'k.wisniewska@helion.pl',
      'active': true,
      'created_at': '2023-09-20T00:00:00.000Z',
    },
  ];

  int _nextUserId = 10;

  @override
  Future<CompanyResponseDto> getCompany() async {
    return CompanyResponseDto.fromJson(_mockCompany);
  }

  @override
  Future<List<UserResponseDto>> getUsers() async {
    return _mockUsers.map(UserResponseDto.fromJson).toList();
  }

  @override
  Future<UserResponseDto> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final data = {
      'id': _nextUserId++,
      'role': 2,
      'company_id': 1,
      'username': username,
      'email': email,
      'active': true,
      'created_at': DateTime.now().toIso8601String(),
    };
    _mockUsers.add(data);
    return UserResponseDto.fromJson(data);
  }

  @override
  Future<void> deleteUser(int userId) async {
    _mockUsers.removeWhere((u) => u['id'] == userId);
  }
}
