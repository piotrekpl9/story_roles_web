import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/models/profile_response_dto.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class GetProfile {
  final AuthRepository repository;

  GetProfile(this.repository);

  Future<Result<ProfileResponseDto>> call() async {
    return repository.getProfile();
  }
}
