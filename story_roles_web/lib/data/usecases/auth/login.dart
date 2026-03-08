import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/models/login_request_dto.dart';
import 'package:story_roles_web/data/models/login_response_dto.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Result<LoginResponseDto>> call({
    required String email,
    required String password,
  }) async {
    return repository.login(
      loginDto: LoginRequestDto(email: email, password: password),
    );
  }
}
