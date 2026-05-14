import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/company_web_api.dart';
import 'package:story_roles_web/data/models/company_response_dto.dart';
import 'package:story_roles_web/data/models/user_response_dto.dart';
import 'package:story_roles_web/data/models/user_summary_response_dto.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';

class CompanyWebApiImpl implements CompanyWebApi {
  final Dio dio;

  CompanyWebApiImpl({required this.dio});

  @override
  Future<CompanyResponseDto> getCompany() async {
    final response = await dio.get(DataConsts.endpoints.getCompany);
    return CompanyResponseDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<CompanyResponseDto> getById(int id) async {
    final response = await dio.get(DataConsts.endpoints.companyById(id));
    final company = response.data['data']['company'] as Map<String, dynamic>;
    return CompanyResponseDto.fromJson(company);
  }

  @override
  Future<List<UserResponseDto>> getUsers() async {
    final company = await getCompany();
    final response = await dio.get(DataConsts.endpoints.getCompanyUsers(company.id));
    final list = response.data['data']['users'] as List? ?? [];
    return list.map((e) => UserResponseDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<UserResponseDto>> getUsersByCompany(int companyId) async {
    final response = await dio.get(DataConsts.endpoints.getCompanyUsers(companyId));
    final list = response.data['data']['users'] as List? ?? [];
    return list.map((e) => UserResponseDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CompanyResponseDto>> getAll() async {
    final response = await dio.get(DataConsts.endpoints.getCompanies);
    final list = response.data['data']['companies'] as List? ?? [];
    return list.map((e) => CompanyResponseDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<UserResponseDto> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final company = await getCompany();
    final response = await dio.post(
      DataConsts.endpoints.getCompanyUsers(company.id),
      data: {'user': {'username': username, 'email': email, 'password': password}},
    );
    return UserResponseDto.fromJson(response.data['data']['user'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteUser(int userId) async {
    final company = await getCompany();
    await dio.delete(DataConsts.endpoints.companyUser(company.id, userId));
  }

  @override
  Future<List<UserSummaryResponseDto>> getAvailableUsers() async {
    final response = await dio.get(DataConsts.endpoints.getAvailableUsers);
    final list = response.data['data']['users'] as List? ?? [];
    return list.map((e) => UserSummaryResponseDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<CompanyResponseDto> create({required String name, required int allowedUsers}) async {
    final response = await dio.post(
      DataConsts.endpoints.companies,
      data: {'name': name, 'allowed_users': allowedUsers, 'active': true},
    );
    return CompanyResponseDto.fromJson(response.data['data']['company'] as Map<String, dynamic>);
  }

  @override
  Future<void> update(int id, {String? name}) async {
    await dio.patch(
      DataConsts.endpoints.companyById(id),
      data: {'company': {if (name != null) 'name': name}},
    );
  }

  @override
  Future<void> delete(int id) async {
    await dio.delete(DataConsts.endpoints.companyById(id));
  }

  @override
  Future<void> assignUser(int companyId, int userId) async {
    await dio.post(
      DataConsts.endpoints.assignUserToCompany(companyId),
      data: {'user_id': userId},
    );
  }
}
