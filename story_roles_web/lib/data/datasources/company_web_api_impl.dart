import 'package:dio/dio.dart';
import 'package:story_roles_web/data/datasources/abstractions/company_web_api.dart';
import 'package:story_roles_web/data/models/company_response_dto.dart';
import 'package:story_roles_web/data/models/user_response_dto.dart';
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
  Future<List<UserResponseDto>> getUsers() async {
    final company = await getCompany();
    final response = await dio.get(DataConsts.endpoints.getCompanyUsers(company.id));
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
}
