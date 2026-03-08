part of 'auth_bloc.dart';

enum AuthStatus { authenticated, registered, unauthenticated, unknown, loading }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? email;
  final DateTime? createdAt;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.email,
    this.createdAt,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    DateTime? createdAt,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, email, createdAt, errorMessage];
}
