part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthRegister extends AuthEvent {
  final Map<String, String> data;
  const AuthRegister(this.data);
}

class AuthLogin extends AuthEvent {
  final Map<String, String> data;
  const AuthLogin(this.data);
}

class AuthCheck extends AuthEvent {}

class AuthLogout extends AuthEvent {}
