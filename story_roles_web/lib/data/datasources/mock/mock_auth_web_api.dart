import 'package:story_roles_web/core/error/failures.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/auth_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_data.dart';
import 'package:story_roles_web/data/models/login_request_dto.dart';
import 'package:story_roles_web/data/models/login_response_dto.dart';
import 'package:story_roles_web/data/models/profile_response_dto.dart';
import 'package:story_roles_web/data/models/register_request_dto.dart';
import 'package:story_roles_web/data/models/register_response_dto.dart';

class MockAuthWebApi implements AuthWebApi {
  String? _currentToken;

  @override
  Future<Result<LoginResponseDto>> login({
    required LoginRequestDto loginData,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final token = MockData.authenticate(loginData.email, loginData.password);
    if (token == null) {
      return Error(const AuthFailure('Invalid email or password'));
    }

    _currentToken = token;
    final userId = MockData.userIdForToken(token)!;
    final user = MockData.users.firstWhere((u) => u.id == userId);

    return Success(
      LoginResponseDto(
        token: token,
        email: user.email,
        createdAt: user.createdAt,
      ),
    );
  }

  @override
  Future<Result<RegisterResponseDto>> register({
    required RegisterRequestDto registerData,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Registration is owner-only in real flow; mock always rejects it.
    return Error(RegistrationFailure());
  }

  @override
  Future<Result<ProfileResponseDto>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final token = _currentToken;
    if (token == null) {
      return Error(const AuthFailure('Not authenticated'));
    }

    final userId = MockData.userIdForToken(token);
    if (userId == null) {
      return Error(const AuthFailure('Invalid token'));
    }

    final user = MockData.users.firstWhere((u) => u.id == userId);
    return Success(
      ProfileResponseDto(email: user.email, createdAt: user.createdAt),
    );
  }
}
