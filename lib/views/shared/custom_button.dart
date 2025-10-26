import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onTap,
    this.width,
    this.bgColor,
  });

  final String label;
  final VoidCallback? onTap;
  final double? width;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: bgColor ?? AppColors.olive,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}
