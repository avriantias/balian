import 'dart:async';

import 'package:balian/services/secureStorage_service.dart';
import 'package:balian/shared/theme.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    _checkToken(); // Panggil fungsi pengecekan token saat halaman dimulai
  }

  // Fungsi untuk mengecek token
  Future<void> _checkToken() async {
    String? token = await _secureStorageService.getToken();
    if (token != null) {
      // Jika token ditemukan, arahkan ke halaman utama
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/bottomnavigation-page');
    } else {
      // Jika token tidak ditemukan, arahkan ke halaman login
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_screen_logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
