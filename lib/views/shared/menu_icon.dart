import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';

class MenuIcon extends StatelessWidget {
  const MenuIcon({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.menu, color: AppColors.olive),
      ),
    );
  }
}
