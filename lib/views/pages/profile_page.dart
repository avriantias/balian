import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:balian/shared/theme.dart';
import 'package:balian/views/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balian/blocs/auth/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          // Arahkan pengguna ke halaman login setelah logout
          Navigator.pushReplacementNamed(context, '/sign-in');
        } else if (state is AuthError) {
          AnimatedSnackBar.material(
            state.message,
            type: AnimatedSnackBarType.error,
          ).show(context);
        }
      },
      child: Scaffold(
        backgroundColor: greyOpBackgroundColor,
        appBar: AppBar(
          backgroundColor: greyOpBackgroundColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'My Profile',
            style: blackTextStyle.copyWith(
              fontSize: 22,
              fontWeight: semibold,
            ),
          ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Handle initial state
            if (state is AuthInitial) {
              // Trigger AuthCheck event untuk memuat data user
              context.read<AuthBloc>().add(AuthCheck());
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff33CC33)),
                ),
              );
            }

            // Handle loading state
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff33CC33)),
                ),
              );
            }

            // Handle error state
            if (state is AuthError) {
              // Tampilkan pesan kesalahan
              AnimatedSnackBar.material(
                state.message,
                type: AnimatedSnackBarType.error,
              ).show(context);

              return const Center(
                child: Text('Terjadi kesalahan.'),
              );
            }

            // Handle authenticated state
            if (state is AuthAuthenticated) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          width: 96,
                          height: 96,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/profile_picture.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.user.name,
                          style: blackTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: medium,
                          ),
                        ),
                        Text(
                          state.user.email,
                          style: orangeTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semibold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        ProfileMenu(
                          iconUrl: 'assets/ic_detail_profile.png',
                          title: 'Detail Profile',
                          onTap: () {},
                        ),
                        ProfileMenu(
                          iconUrl: 'assets/ic_alamat_saya.png',
                          title: 'Alamat Saya',
                          onTap: () {
                            Navigator.pushNamed(context, '/address-page');
                          },
                        ),
                        ProfileMenu(
                          iconUrl: 'assets/ic_privasi.png',
                          title: 'Privasi dan Keamanan',
                          onTap: () {},
                        ),
                        ProfileMenu(
                          iconUrl: 'assets/ic_bantuan.png',
                          title: 'Bantuan',
                          onTap: () {},
                        ),
                        ProfileMenu(
                          iconUrl: 'assets/ic_sk.png',
                          title: 'Syarat dan Ketentuan',
                          onTap: () {},
                        ),
                        ProfileMenu(
                          iconUrl: 'assets/ic_keluar.png',
                          title: 'Keluar',
                          onTap: () {
                            // Trigger the logout event
                            context.read<AuthBloc>().add(AuthLogout());
                            Navigator.pushReplacementNamed(context, '/sign-in');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            // Handle unauthenticated state
            return const Center(
              child: Text('Anda belum masuk.'),
            );
          },
        ),
      ),
    );
  }
}
