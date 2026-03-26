import 'package:story_roles_web/data/models/company_response_dto.dart';
import 'package:story_roles_web/data/models/user_response_dto.dart';

abstract class CompanyWebApi {
  Future<CompanyResponseDto> getCompany();
  Future<List<UserResponseDto>> getUsers();
  Future<UserResponseDto> createUser({
    required String username,
    required String email,
    required String password,
  });
  Future<void> deleteUser(int userId);
}
