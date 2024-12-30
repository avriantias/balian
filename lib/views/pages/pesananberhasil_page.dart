import 'package:balian/shared/theme.dart';
import 'package:balian/views/pages/bottomnavigation_page.dart';
import 'package:balian/views/widgets/buttons.dart';
import 'package:flutter/material.dart';

class PesananberhasilPage extends StatelessWidget {
  const PesananberhasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyOpBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/img_pesanan_berhasil.png',
                width: 175,
                height: 175,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'Berhasil! ',
              style: blackTextStyle.copyWith(
                fontSize: 22,
                fontWeight: semibold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Pesanan Anda akan segera diproses',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            CustomFilledButton(
                title: 'Lihat Detail',
                width: 127,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BottomnavigationPage(initialIndex: 2),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
