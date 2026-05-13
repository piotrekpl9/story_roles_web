import 'package:story_roles_web/data/models/company_response_dto.dart';
import 'package:story_roles_web/data/models/user_response_dto.dart';
import 'package:story_roles_web/data/models/user_summary_response_dto.dart';

abstract class CompanyWebApi {
  Future<CompanyResponseDto> getCompany();
  Future<CompanyResponseDto> getById(int id);
  Future<List<UserResponseDto>> getUsers();
  Future<List<UserResponseDto>> getUsersByCompany(int companyId);
  Future<List<CompanyResponseDto>> getAll();
  Future<UserResponseDto> createUser({
    required String username,
    required String email,
    required String password,
  });
  Future<void> deleteUser(int userId);
  Future<List<UserSummaryResponseDto>> getAvailableUsers();
  Future<CompanyResponseDto> create({required String name});
  Future<void> update(int id, {String? name});
  Future<void> delete(int id);
  Future<void> assignUser(int companyId, int userId);
}
