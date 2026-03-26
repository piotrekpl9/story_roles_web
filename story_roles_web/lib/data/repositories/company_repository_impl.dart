import 'package:story_roles_web/data/datasources/abstractions/company_web_api.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/entities/user.dart';
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
  Future<List<User>> getUsers() async {
    final dtos = await _companyWebApi.getUsers();
    return dtos.map((e) => e.toDomain()).toList();
  }
}
