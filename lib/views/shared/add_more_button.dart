import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart' show AppColors;

class AddMoreButton extends StatelessWidget {
  const AddMoreButton({super.key, this.onTap, this.label});

  final VoidCallback? onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: AppColors.black.withValues(alpha: 0.2),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: SizedBox(
          height: 35.0,
          width: double.infinity,
          child: Row(
            spacing: 5.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label ?? "Add More",
                // style: AppTheme.body14.copyWith(color: AppColors.green),
              ),
              Icon(Icons.add_outlined, color: AppColors.green, size: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
