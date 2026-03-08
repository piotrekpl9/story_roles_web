import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<Result> call() async {
    return repository.logout();
  }
}
