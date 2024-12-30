part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  final UserModel user;

  const AuthAuthenticated(this.token, this.user);

  @override
  List<Object?> get props => [token, user];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthUnauthenticated extends AuthState {}

class AuthLoggedOut extends AuthState {}
