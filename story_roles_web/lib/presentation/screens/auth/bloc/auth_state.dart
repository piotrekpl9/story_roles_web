part of 'auth_bloc.dart';

enum AuthStatus { authenticated, registered, unauthenticated, unknown, loading }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? email;
  final DateTime? createdAt;
  final bool isAdmin;
  final int? companyId;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.email,
    this.createdAt,
    this.isAdmin = false,
    this.companyId,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    DateTime? createdAt,
    bool? isAdmin,
    int? companyId,
    bool clearCompanyId = false,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      isAdmin: isAdmin ?? this.isAdmin,
      companyId: clearCompanyId ? null : (companyId ?? this.companyId),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, email, createdAt, isAdmin, companyId, errorMessage];
}
