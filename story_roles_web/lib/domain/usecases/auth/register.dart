import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';
import 'package:story_roles_web/domain/usecases/auth/auth_consts.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Result<void>> call({
    required String email,
    required String password,
  }) {
    if (!email.contains('@')) {
      return Future.value(
        const Error(ValidationFailure('Invalid email format')),
      );
    }
    if (password.length < AuthConsts.minPasswordLength) {
      return Future.value(
        const Error(ValidationFailure(
          'Password must be at least ${AuthConsts.minPasswordLength} characters',
        )),
      );
    }
    return repository.register(email: email, password: password);
  }
}
