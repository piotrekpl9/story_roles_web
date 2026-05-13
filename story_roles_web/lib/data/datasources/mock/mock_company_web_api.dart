import 'package:story_roles_web/data/datasources/abstractions/company_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_data.dart';
import 'package:story_roles_web/data/models/company_response_dto.dart';
import 'package:story_roles_web/data/models/user_response_dto.dart';
import 'package:story_roles_web/data/models/user_summary_response_dto.dart';

class MockCompanyWebApi implements CompanyWebApi {
  final List<UserResponseDto> _users = List.of(MockData.users);
  int _nextUserId = 10;
  final List<CompanyResponseDto> _companies = [
    CompanyResponseDto(id: 1, name: 'Helion S.A.', allowedUsers: 10, active: true, createdAt: DateTime(2023, 6, 1)),
    CompanyResponseDto(id: 2, name: 'Znak Sp. z o.o.', allowedUsers: 5, active: true, createdAt: DateTime(2022, 3, 15)),
    CompanyResponseDto(id: 3, name: 'PWN Group', allowedUsers: 20, active: false, createdAt: DateTime(2021, 1, 10)),
    CompanyResponseDto(id: 4, name: 'Rebis Publishing', allowedUsers: 8, active: true, createdAt: DateTime(2024, 2, 20)),
  ];
  int _nextCompanyId = 5;

  @override
  Future<CompanyResponseDto> getCompany() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.company;
  }

  @override
  Future<CompanyResponseDto> getById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _companies.firstWhere((c) => c.id == id);
  }

  @override
  Future<List<UserResponseDto>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_users);
  }

  @override
  Future<List<UserResponseDto>> getUsersByCompany(int companyId) async {
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

    if (_users.length >= MockData.company.allowedUsers) {
      throw Exception('User limit reached (${MockData.company.allowedUsers})');
    }

    final user = UserResponseDto(
      id: _nextUserId++,
      email: email,
      isAdmin: false,
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

  @override
  Future<List<CompanyResponseDto>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_companies);
  }

  @override
  Future<List<UserSummaryResponseDto>> getAvailableUsers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(MockData.availableUsers);
  }

  @override
  Future<CompanyResponseDto> create({required String name}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final company = CompanyResponseDto(
      id: _nextCompanyId++,
      name: name,
      allowedUsers: 0,
      active: true,
      createdAt: DateTime.now(),
    );
    _companies.add(company);
    return company;
  }

  @override
  Future<void> update(int id, {String? name}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _companies.indexWhere((c) => c.id == id);
    if (index == -1) return;
    final existing = _companies[index];
    _companies[index] = CompanyResponseDto(
      id: existing.id,
      name: name ?? existing.name,
      allowedUsers: existing.allowedUsers,
      active: existing.active,
      createdAt: existing.createdAt,
    );
  }

  @override
  Future<void> delete(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _companies.removeWhere((c) => c.id == id);
  }

  @override
  Future<void> assignUser(int companyId, int userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
