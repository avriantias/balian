import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balian/blocs/auth/auth_bloc.dart';
import 'package:balian/shared/theme.dart';
import 'package:balian/views/widgets/buttons.dart';
import 'package:balian/views/widgets/forms.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/bottomnavigation-page');
          } else if (state is AuthError) {
            AnimatedSnackBar.material(
              state.message,
              type: AnimatedSnackBarType.error,
            ).show(context);
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Masuk',
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(
                    fontSize: 26,
                    fontWeight: bold,
                  ),
                ),
                Text(
                  'Silahkan masuk untuk lanjut ke aplikasi',
                  textAlign: TextAlign.center,
                  style: greyTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: regular,
                  ),
                ),
                const SizedBox(height: 50),
                CustomFormField(
                  title: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  title: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Aksi untuk lupa password (jika diperlukan)
                    },
                    child: Text(
                      'Lupa Password?',
                      style: orangeTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomFilledButton(
                  title: 'Masuk',
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;

                    if (email.isEmpty || password.isEmpty) {
                      AnimatedSnackBar.material(
                        'Email dan password tidak boleh kosong',
                        type: AnimatedSnackBarType.error,
                      ).show(context);
                      return;
                    }

                    final data = {
                      'email': email,
                      'password': password,
                    };
                    context.read<AuthBloc>().add(AuthLogin(data));
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: greyTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    CustomTextButton(
                      title: 'Daftar',
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign-up');
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
