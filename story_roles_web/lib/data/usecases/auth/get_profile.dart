import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/user.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class GetProfile {
  final AuthRepository repository;

  GetProfile(this.repository);

  Future<Result<User>> call() => repository.getProfile();
}
