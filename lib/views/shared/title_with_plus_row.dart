import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';

class TitleWithPlusRow extends StatelessWidget {
  const TitleWithPlusRow({super.key, required this.title, this.onPlus});

  final String title;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 12.0,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        InkWell(
          onTap: onPlus,
          child: Icon(CupertinoIcons.plus_circle_fill, color: AppColors.green),
        ),
      ],
    );
  }
}
