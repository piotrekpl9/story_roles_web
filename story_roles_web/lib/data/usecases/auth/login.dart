import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/user.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Result<User>> call({
    required String email,
    required String password,
  }) =>
      repository.login(email: email, password: password);
}
