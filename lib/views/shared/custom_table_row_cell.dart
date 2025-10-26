import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';

class CustomTableRowCell extends StatelessWidget {
  const CustomTableRowCell({super.key, required this.label, this.textAlign});

  final String label;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 24.0),
      child: Text(
        label,
        textAlign: textAlign ?? TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}
