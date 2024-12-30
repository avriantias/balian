import 'package:balian/blocs/address/address_bloc.dart';
import 'package:balian/blocs/auth/auth_bloc.dart';
import 'package:balian/blocs/cart/cart_bloc.dart';
import 'package:balian/blocs/product/product_bloc.dart';
import 'package:balian/blocs/transaction/transaction_bloc.dart';
import 'package:balian/services/address_service.dart';
import 'package:balian/services/cart_service.dart';
import 'package:balian/services/transaction_service.dart';
import 'package:balian/views/pages/add_address_page.dart';
import 'package:balian/views/pages/address_page.dart';
import 'package:balian/views/pages/bottomnavigation_page.dart';
import 'package:balian/views/pages/edit_address_page.dart';
import 'package:balian/views/pages/home_page.dart';
import 'package:balian/views/pages/pesananberhasil_page.dart';
import 'package:balian/views/pages/signin_page.dart';
import 'package:balian/views/pages/signup_page.dart';
import 'package:balian/views/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(),
        ),
        BlocProvider(
          create: (_) => CartBloc(cartService: CartService()),
        ),
        BlocProvider(
          create: (context) => AddressBloc(addressService: AddressService()),
        ),
        BlocProvider(
            create: (context) =>
                TransactionBloc(transactionService: TransactionService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/sign-in': (context) => const SigninPage(),
          '/sign-up': (context) => const SignupPage(),
          '/bottomnavigation-page': (context) => const BottomnavigationPage(),
          '/home-page': (context) => const HomePage(),
          '/pesananberhasil-page': (context) => const PesananberhasilPage(),
          '/address-page': (context) => const AddressPage(),
          '/profile-page': (context) => const BottomnavigationPage(),
          '/add-address-page': (context) => const AddAddressPage(),
          '/edit-address-page': (context) {
            final addressId = ModalRoute.of(context)!.settings.arguments as int;
            return EditAddressPage(addressId: addressId);
          },
        },
      ),
    );
  }
}
