import 'package:story_roles_web/data/datasources/abstractions/company_web_api.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/entities/user.dart';
import 'package:story_roles_web/domain/entities/user_summary.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyWebApi _companyWebApi;

  CompanyRepositoryImpl({required CompanyWebApi companyWebApi})
      : _companyWebApi = companyWebApi;

  @override
  Future<Company> getCompany() async {
    final dto = await _companyWebApi.getCompany();
    return dto.toDomain();
  }

  @override
  Future<Company> getById(int id) async {
    final dto = await _companyWebApi.getById(id);
    return dto.toDomain();
  }

  @override
  Future<List<User>> getUsers() async {
    final dtos = await _companyWebApi.getUsers();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<User>> getUsersByCompany(int companyId) async {
    final dtos = await _companyWebApi.getUsersByCompany(companyId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Company>> getAll() async {
    final dtos = await _companyWebApi.getAll();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<UserSummary>> getAvailableUsers() async {
    final dtos = await _companyWebApi.getAvailableUsers();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Company> create({required String name, required int allowedUsers}) async {
    final dto = await _companyWebApi.create(name: name, allowedUsers: allowedUsers);
    return dto.toDomain();
  }

  @override
  Future<void> update(int id, {String? name}) async {
    await _companyWebApi.update(id, name: name);
  }

  @override
  Future<void> delete(int id) async {
    await _companyWebApi.delete(id);
  }

  @override
  Future<void> assignUser(int companyId, int userId) async {
    await _companyWebApi.assignUser(companyId, userId);
  }
}
