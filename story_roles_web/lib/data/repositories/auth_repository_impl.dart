import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/auth_web_api.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';
import 'package:story_roles_web/data/models/login_request_dto.dart';
import 'package:story_roles_web/data/models/login_response_dto.dart';
import 'package:story_roles_web/data/models/register_request_dto.dart';
import 'package:story_roles_web/data/models/register_response_dto.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthWebApi webApi;
  final StorageDataSource storageDataSource;

  AuthRepositoryImpl({
    required this.webApi,
    required this.storageDataSource,
  });

  @override
  Future<Result<LoginResponseDto>> login({
    required LoginRequestDto loginDto,
  }) async {
    final result = await webApi.login(loginData: loginDto);
    final dto = result.dataOrNull;
    if (result.isSuccess && dto != null) {
      await storageDataSource.writeToken(dto.token);
      await storageDataSource.writeUserData(
        email: dto.email,
        createdAt: dto.createdAt?.toIso8601String(),
      );
    }
    return result;
  }

  @override
  Future<Result<RegisterResponseDto>> register({
    required RegisterRequestDto registerDto,
  }) async {
    return await webApi.register(registerData: registerDto);
  }

  @override
  Future<Result> logout() async {
    await storageDataSource.removeToken();
    return Success(());
  }
}
