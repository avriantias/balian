import 'package:balian/shared/theme.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final String iconUrl;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenu({
    super.key,
    required this.iconUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconUrl,
              width: 44,
            ),
            const SizedBox(
              width: 18,
            ),
            Text(
              title,
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
