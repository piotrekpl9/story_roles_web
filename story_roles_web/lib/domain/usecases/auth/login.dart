import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/user.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Result<User>> call({
    required String email,
    required String password,
  }) {
    if (!email.contains('@')) {
      return Future.value(
        const Error(ValidationFailure('Invalid email format')),
      );
    }
    if (password.isEmpty) {
      return Future.value(
        const Error(ValidationFailure('Password must not be empty')),
      );
    }
    return repository.login(email: email, password: password);
  }
}
