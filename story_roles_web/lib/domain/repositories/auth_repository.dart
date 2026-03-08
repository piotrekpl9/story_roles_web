import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/models/login_request_dto.dart';
import 'package:story_roles_web/data/models/login_response_dto.dart';
import 'package:story_roles_web/data/models/register_request_dto.dart';
import 'package:story_roles_web/data/models/register_response_dto.dart';

abstract class AuthRepository {
  Future<Result<LoginResponseDto>> login({required LoginRequestDto loginDto});
  Future<Result<RegisterResponseDto>> register({required RegisterRequestDto registerDto});
  Future<Result> logout();
}
