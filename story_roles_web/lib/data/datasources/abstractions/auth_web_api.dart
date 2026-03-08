import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/models/login_request_dto.dart';
import 'package:story_roles_web/data/models/login_response_dto.dart';
import 'package:story_roles_web/data/models/register_request_dto.dart';
import 'package:story_roles_web/data/models/register_response_dto.dart';

abstract class AuthWebApi {
  Future<Result<LoginResponseDto>> login({required LoginRequestDto loginData});
  Future<Result<RegisterResponseDto>> register({required RegisterRequestDto registerData});
}
