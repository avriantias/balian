import 'package:balian/shared/theme.dart';
import 'package:balian/views/pages/cart_page.dart';
import 'package:balian/views/pages/home_page.dart';
import 'package:balian/views/pages/order_page.dart';
import 'package:balian/views/pages/profile_page.dart';
import 'package:flutter/material.dart';

class BottomnavigationPage extends StatefulWidget {
  final int initialIndex;
  const BottomnavigationPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<BottomnavigationPage> createState() => _BottomnavigationPageState();
}

class _BottomnavigationPageState extends State<BottomnavigationPage> {
  late int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final screen = [
    const HomePage(),
    const CartPage(),
    const OrderPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Tambahkan method ini
  void updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: screen.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: lightBackgroundColor,
        selectedItemColor: greenColor,
        unselectedItemColor: greyColor,
        selectedLabelStyle: greenTextStyle.copyWith(
          fontSize: 12,
          fontWeight: regular,
        ),
        unselectedLabelStyle: greyTextStyle.copyWith(
          fontSize: 12,
          fontWeight: regular,
        ),
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon_beranda.png',
              color: _selectedIndex == 0 ? greenColor : greyColor,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon_keranjang.png',
              color: _selectedIndex == 1 ? greenColor : greyColor,
            ),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon_pesanan.png',
              color: _selectedIndex == 2 ? greenColor : greyColor,
            ),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon_profile.png',
              color: _selectedIndex == 3 ? greenColor : greyColor,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
