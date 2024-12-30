import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:balian/shared/theme.dart';
import 'package:balian/views/widgets/buttons.dart';
import 'package:balian/views/widgets/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balian/blocs/auth/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Jika register berhasil dan token diterima, arahkan ke halaman utama
          Navigator.pushNamedAndRemoveUntil(
              context, '/sign-in', (route) => false);
          AnimatedSnackBar.material(
            'Registrasi Berhasil!, Silahkan Login!',
            type: AnimatedSnackBarType.success,
          ).show(context);
        } else if (state is AuthError) {
          AnimatedSnackBar.material(
            state.message,
            type: AnimatedSnackBarType.error,
          ).show(context);
        }
      },
      child: Scaffold(
        backgroundColor: lightBackgroundColor,
        appBar: AppBar(
          backgroundColor: lightBackgroundColor,
          leading: IconButton(
            icon: Image.asset('assets/ic_back_page.png'),
            onPressed: () {
              Navigator.pushNamed(context, '/sign-in');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, top: 10, left: 20),
            child: Column(
              children: [
                Text(
                  'Daftar',
                  textAlign: TextAlign.center,
                  style:
                      blackTextStyle.copyWith(fontSize: 26, fontWeight: bold),
                ),
                Text(
                  'Silahkan daftar untuk melanjutkan aplikasi',
                  textAlign: TextAlign.center,
                  style:
                      greyTextStyle.copyWith(fontSize: 16, fontWeight: regular),
                ),
                const SizedBox(height: 50),
                CustomFormField(title: 'Nama', controller: nameController),
                const SizedBox(height: 20),
                CustomFormField(title: 'Email', controller: emailController),
                const SizedBox(height: 20),
                CustomFormField(
                    title: 'Password',
                    controller: passwordController,
                    obscureText: true),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Password terdiri dari 8 karakter',
                      style: greyTextStyle.copyWith(
                          fontSize: 14, fontWeight: regular)),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                    title: 'Confirmation Password',
                    controller: confirmPasswordController,
                    obscureText: true),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Password terdiri dari 8 karakter',
                      style: greyTextStyle.copyWith(
                          fontSize: 14, fontWeight: regular)),
                ),
                const SizedBox(height: 30),
                CustomFilledButton(
                  title: 'Daftar',
                  onPressed: () {
                    final name = nameController.text;
                    final email = emailController.text;
                    final password = passwordController.text;
                    final confirmPassword = confirmPasswordController.text;

                    if (name.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty) {
                      AnimatedSnackBar.material(
                        'Semua field harus diisi!',
                        type: AnimatedSnackBarType.error,
                      ).show(context);
                      return;
                    }

                    if (password != confirmPassword) {
                      AnimatedSnackBar.material(
                        'Password dan konfirmasi password tidak cocok',
                        type: AnimatedSnackBarType.error,
                      ).show(context);
                      return;
                    }

                    final data = {
                      'name': name,
                      'email': email,
                      'password': password,
                      'password_confirmation': confirmPassword,
                    };
                    context.read<AuthBloc>().add(AuthRegister(data));
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sudah punya akun? ',
                        style: greyTextStyle.copyWith(fontSize: 14)),
                    CustomTextButton(
                      title: 'Masuk',
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign-in');
                      },
                      width: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
