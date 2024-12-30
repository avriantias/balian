import 'package:balian/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balian/services/auth_service.dart';
import 'package:balian/services/secureStorage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();
  final SecureStorageService _storage = SecureStorageService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _authService.login(event.data);
        // Memastikan respons valid
        // ignore: unnecessary_null_comparison
        if (response != null && response['data'] != null) {
          final token = response['data']['token'];
          final userData = response['data']['user'];

          await _storage.saveToken(token);

          // Memproses data user menggunakan UserModel
          final user = UserModel.fromJson(userData);

          // Emit state Authenticated dengan token dan user
          emit(AuthAuthenticated(token, user));
        } else {
          emit(const AuthError('Token atau data user tidak ditemukan'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthCheck>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await _storage.getToken();

        if (token != null) {
          // Ambil data user dari API menggunakan token
          final response = await _authService.getUserByToken(token);

          if (response != null && response['data'] != null) {
            // Respons API langsung memiliki data user di dalam `response['data']`
            final userData = response['data'];
            final user = UserModel.fromJson(userData);

            // Emit state Authenticated
            emit(AuthAuthenticated(token, user));
          } else {
            emit(const AuthError('Data user tidak ditemukan'));
          }
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthRegister>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authService.register(event.data);

        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthLogout>((event, emit) async {
      emit(AuthLoading());
      await _authService.logout();
      emit(AuthLoggedOut());
    });
  }
}
