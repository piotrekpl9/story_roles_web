import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/auth_web_api.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';
import 'package:story_roles_web/data/models/login_request_dto.dart';
import 'package:story_roles_web/data/models/register_request_dto.dart';
import 'package:story_roles_web/domain/entities/user.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthWebApi webApi;
  final StorageDataSource storageDataSource;

  AuthRepositoryImpl({
    required this.webApi,
    required this.storageDataSource,
  });

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    final result = await webApi.login(
      loginData: LoginRequestDto(email: email, password: password),
    );
    if (!result.isSuccess) return Error(result.failureOrNull!);

    final dto = result.dataOrNull!;
    await storageDataSource.writeToken(dto.token);

    final profileResult = await webApi.getProfile();
    final user = profileResult.isSuccess
        ? profileResult.dataOrNull!.toDomain()
        : User(email: dto.email, isAdmin: false, createdAt: dto.createdAt);

    await storageDataSource.writeUserData(
      email: user.email,
      createdAt: user.createdAt?.toIso8601String(),
      isAdmin: user.isAdmin,
    );

    return Success(user);
  }

  @override
  Future<Result<void>> register({
    required String email,
    required String password,
  }) async {
    final result = await webApi.register(
      registerData: RegisterRequestDto(email: email, password: password),
    );
    if (!result.isSuccess) return Error(result.failureOrNull!);
    return const Success(null);
  }

  @override
  Future<Result<void>> logout() async {
    await storageDataSource.removeToken();
    return const Success(null);
  }

  @override
  Future<Result<User?>> getSession() async {
    final token = await storageDataSource.readToken();
    if (token == null) return const Success(null);

    final profileResult = await webApi.getProfile();
    if (profileResult.isSuccess) {
      final user = profileResult.dataOrNull!.toDomain();
      await storageDataSource.writeUserData(
        email: user.email,
        createdAt: user.createdAt?.toIso8601String(),
        isAdmin: user.isAdmin,
      );
      return Success(user);
    }

    final userData = await storageDataSource.readUserData();
    final email = userData['email'];
    if (email == null) return const Success(null);

    final isAdmin = userData['is_admin'] == 'true';
    final createdAtStr = userData['created_at'];
    return Success(User(
      email: email,
      isAdmin: isAdmin,
      createdAt: createdAtStr != null ? DateTime.tryParse(createdAtStr) : null,
    ));
  }

  @override
  Future<Result<User>> getProfile() async {
    final result = await webApi.getProfile();
    if (!result.isSuccess) return Error(result.failureOrNull!);
    return Success(result.dataOrNull!.toDomain());
  }
}
