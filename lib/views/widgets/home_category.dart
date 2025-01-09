import 'package:balian/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeCategory extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const HomeCategory({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        height: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isActive ? hijauColor : borderColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff33CC33)),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported, size: 40),
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: greyTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semibold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
