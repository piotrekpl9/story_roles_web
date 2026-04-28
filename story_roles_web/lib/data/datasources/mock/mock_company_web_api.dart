import 'package:story_roles_web/data/datasources/abstractions/company_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_data.dart';
import 'package:story_roles_web/data/models/company_response_dto.dart';
import 'package:story_roles_web/data/models/user_response_dto.dart';

class MockCompanyWebApi implements CompanyWebApi {
  final List<UserResponseDto> _users = List.of(MockData.users);
  int _nextUserId = 10;

  @override
  Future<CompanyResponseDto> getCompany() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.company;
  }

  @override
  Future<List<UserResponseDto>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_users);
  }

  @override
  Future<UserResponseDto> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final activeCount = _users.where((u) => u.active).length;
    if (activeCount >= MockData.company.allowedUsers) {
      throw Exception('User limit reached (${MockData.company.allowedUsers})');
    }

    final user = UserResponseDto(
      id: _nextUserId++,
      role: 2, // member
      companyId: MockData.company.id,
      username: username,
      email: email,
      active: true,
      createdAt: DateTime.now(),
    );
    _users.add(user);
    return user;
  }

  @override
  Future<void> deleteUser(int userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _users.removeWhere((u) => u.id == userId);
  }
}
