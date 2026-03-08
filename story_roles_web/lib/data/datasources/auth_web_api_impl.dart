import 'package:dio/dio.dart';
import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/auth_web_api.dart';
import 'package:story_roles_web/data/models/login_request_dto.dart';
import 'package:story_roles_web/data/models/login_response_dto.dart';
import 'package:story_roles_web/data/models/register_request_dto.dart';
import 'package:story_roles_web/data/models/register_response_dto.dart';
import 'package:story_roles_web/data/utils/data_consts.dart';

class AuthWebApiImpl implements AuthWebApi {
  final Dio dio;

  AuthWebApiImpl({required this.dio});

  @override
  Future<Result<LoginResponseDto>> login({
    required LoginRequestDto loginData,
  }) async {
    try {
      final response = await dio.post(
        DataConsts.endpoints.login,
        data: {
          DataConsts.apiParameters.user: {
            DataConsts.apiParameters.email: loginData.email,
            DataConsts.apiParameters.password: loginData.password,
          },
        },
      );
      final data = response.data[DataConsts.dataKeys.data] as Map<String, dynamic>;
      final token = response.headers.value('authorization') ??
          response.headers.value('Authorization') ??
          data['token'] as String? ??
          '';
      return Success(
        LoginResponseDto.fromJson({...data, 'token': token}),
      );
    } catch (e) {
      return Error(const AuthFailure('Login failed'));
    }
  }

  @override
  Future<Result<RegisterResponseDto>> register({
    required RegisterRequestDto registerData,
  }) async {
    try {
      final response = await dio.post(
        DataConsts.endpoints.register,
        data: {
          DataConsts.apiParameters.user: {
            DataConsts.apiParameters.email: registerData.email,
            DataConsts.apiParameters.password: registerData.password,
          },
        },
      );
      return Success(
        RegisterResponseDto.fromJson(response.data[DataConsts.dataKeys.data]),
      );
    } catch (e) {
      return Error(RegistrationFailure());
    }
  }
}
