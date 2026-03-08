import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';
import 'package:story_roles_web/data/usecases/auth/login.dart';
import 'package:story_roles_web/data/usecases/auth/logout.dart';
import 'package:story_roles_web/data/usecases/auth/register.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Register _register;
  final Logout _logout;
  final StorageDataSource _storage;

  AuthBloc({
    required Login login,
    required Register register,
    required Logout logout,
    required StorageDataSource storage,
  })  : _logout = logout,
        _login = login,
        _register = register,
        _storage = storage,
        super(const AuthState(status: AuthStatus.unknown)) {
    on<AppStarted>(_onAppStarted);
    on<LoginClicked>(_onLoginRequested);
    on<RegisterClicked>(_onRegisterRequested);
    on<LogoutClicked>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _storage.readToken();
    if (token == null) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      return;
    }
    final userData = await _storage.readUserData();
    final email = userData['email'];
    final createdAtStr = userData['created_at'];
    emit(state.copyWith(
      status: AuthStatus.authenticated,
      email: email,
      createdAt: createdAtStr != null ? DateTime.tryParse(createdAtStr) : null,
    ));
  }

  Future<void> _onLoginRequested(
    LoginClicked event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final result = await _login(email: event.email, password: event.password);

    result.fold(
      onSuccess: (dto) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          email: dto.email,
          createdAt: dto.createdAt,
          errorMessage: null,
        ),
      ),
      onError: (_) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Login failed',
        ),
      ),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterClicked event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final result = await _register(
      email: event.email,
      password: event.password,
    );

    result.fold(
      onSuccess: (_) {
        emit(state.copyWith(status: AuthStatus.registered));
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      },
      onError: (_) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Registration failed',
        ),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutClicked event,
    Emitter<AuthState> emit,
  ) async {
    await _logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
