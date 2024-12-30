import 'package:balian/shared/theme.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String title;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomFormField({
    super.key,
    required this.title,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: greyOpBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          obscureText: obscureText,
          controller: controller,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          style: blackTextStyle.copyWith(fontSize: 14),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            hintText: title,
          ),
        ),
      ),
    );
  }
}

class CustomFormFieldNumber extends StatelessWidget {
  final String title;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomFormFieldNumber({
    super.key,
    required this.title,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: greyOpBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          keyboardType: TextInputType.number,
          obscureText: obscureText,
          controller: controller,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          style: blackTextStyle.copyWith(fontSize: 14),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            hintText: title,
          ),
        ),
      ),
    );
  }
}
