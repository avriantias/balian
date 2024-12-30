import 'package:balian/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeProduct extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final String variant;
  final VoidCallback onTap;

  const HomeProduct({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.variant,
    required this.onTap,
  });

  String formatCurrency(double price) {
    final NumberFormat formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(price.toInt()); // Konversi ke integer
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              // height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 60);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semibold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              variant.isNotEmpty ? variant : "Tidak Ada Varian",
              style: greyTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semibold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rp. ${formatCurrency(price)}",
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: bold,
                  ),
                ),
                const Icon(Icons.add_box_rounded, color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
