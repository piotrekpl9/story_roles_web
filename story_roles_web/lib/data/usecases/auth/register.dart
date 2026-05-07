import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Result<void>> call({
    required String email,
    required String password,
  }) =>
      repository.register(email: email, password: password);
}
