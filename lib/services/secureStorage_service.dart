// ignore_for_file: file_names

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Menyimpan token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // Mengambil token
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Menghapus token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}
