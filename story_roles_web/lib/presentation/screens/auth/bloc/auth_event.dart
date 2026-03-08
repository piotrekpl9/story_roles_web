part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginClicked extends AuthEvent {
  final String email;
  final String password;

  const LoginClicked({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterClicked extends AuthEvent {
  final String email;
  final String password;

  const RegisterClicked({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutClicked extends AuthEvent {}

class AppStarted extends AuthEvent {}
