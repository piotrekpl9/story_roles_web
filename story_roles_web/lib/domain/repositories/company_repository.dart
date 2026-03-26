import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/entities/user.dart';

abstract class CompanyRepository {
  Future<Company> getCompany();
  Future<List<User>> getUsers();
}
