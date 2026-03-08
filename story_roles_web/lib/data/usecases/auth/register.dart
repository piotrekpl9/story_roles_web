import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/models/register_request_dto.dart';
import 'package:story_roles_web/data/models/register_response_dto.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Result<RegisterResponseDto>> call({
    required String email,
    required String password,
  }) async {
    return repository.register(
      registerDto: RegisterRequestDto(email: email, password: password),
    );
  }
}
