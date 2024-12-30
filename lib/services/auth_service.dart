// auth_service.dart
import 'package:balian/services/secureStorage_service.dart';
import 'package:balian/shared/shared_values.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Map<String, dynamic>> login(Map<String, String> data) async {
    try {
      final response = await _dio.post('/login', data: data);

      if (response.statusCode == 200) {
        final responseData = response.data; // Respons dari API
        // Log respons

        final token = responseData['data']['token'];
        await _secureStorageService.saveToken(token);
        return responseData;
      } else {
        throw Exception('Gagal login, status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Email atau Password salah');
    }
  }

  Future<void> register(Map<String, String> data) async {
    try {
      final response = await _dio.post('/register', data: data);
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('Gagal mendaftar, status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserByToken(String token) async {
    try {
      final response = await _dio.get(
        '/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data; // Pastikan data sesuai format yang diharapkan
      } else {
        return null;
      }
    } catch (e) {
      return null; // Kembalikan null jika terjadi error
    }
  }

  // Logout Function
  Future<void> logout() async {
    await _secureStorageService
        .deleteToken(); // Menghapus token dari secure storage
  }

  // Get Token
  Future<String?> get token async {
    return await _secureStorageService
        .getToken(); // Mengambil token dari secure storage
  }
}
