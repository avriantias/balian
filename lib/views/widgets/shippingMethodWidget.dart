// ignore_for_file: file_names

import 'package:balian/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:balian/models/shippingMethod_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingMethodWidget extends StatefulWidget {
  final List<ShippingMethod> shippingMethods;
  final ValueChanged<ShippingMethod> onMethodSelected;

  const ShippingMethodWidget({
    super.key,
    required this.shippingMethods,
    required this.onMethodSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ShippingMethodWidgetState createState() => _ShippingMethodWidgetState();
}

class _ShippingMethodWidgetState extends State<ShippingMethodWidget> {
  ShippingMethod? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: widget.shippingMethods.map((method) {
          bool isSelected = method == selectedMethod;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMethod = method;
              });
              widget.onMethodSelected(method);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? greenColor : whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: greenColor,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      color: isSelected ? whiteColor : greenColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.plusJakartaSans.toString(),
                    ),
                  ),
                  Text(
                    'Rp ${method.cost}',
                    style: TextStyle(
                      color: isSelected ? whiteColor : greenColor,
                      fontSize: 12,
                      fontFamily: GoogleFonts.plusJakartaSans.toString(),
                    ),
                  ),
                  Text(
                    method.description,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 12,
                      fontFamily: GoogleFonts.plusJakartaSans.toString(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
