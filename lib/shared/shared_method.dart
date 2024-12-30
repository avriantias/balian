import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showCustomSnackbar(BuildContext context, String massage) {
  AnimatedSnackBar.material(
    massage,
    type: AnimatedSnackBarType.success,
  ).show(context);
}

String formatCurrency(double price) {
  final NumberFormat formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  return formatter.format(price);
}
