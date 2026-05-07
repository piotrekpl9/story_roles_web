import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login({required String email, required String password});
  Future<Result<void>> register({required String email, required String password});
  Future<Result<void>> logout();
  Future<Result<User?>> getSession();
  Future<Result<User>> getProfile();
}
