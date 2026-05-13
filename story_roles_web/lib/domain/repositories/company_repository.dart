import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/entities/user.dart';
import 'package:story_roles_web/domain/entities/user_summary.dart';

abstract class CompanyRepository {
  Future<Company> getCompany();
  Future<Company> getById(int id);
  Future<List<User>> getUsers();
  Future<List<User>> getUsersByCompany(int companyId);
  Future<List<Company>> getAll();
  Future<List<UserSummary>> getAvailableUsers();
  Future<Company> create({required String name});
  Future<void> update(int id, {String? name});
  Future<void> delete(int id);
  Future<void> assignUser(int companyId, int userId);
}
