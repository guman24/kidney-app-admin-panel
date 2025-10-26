import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar.success({super.key, required String text})
    : super(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, size: 24, color: AppColors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14, color: AppColors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.olive,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      );

  CustomSnackBar.info({super.key, required String text})
    : super(
        content: Row(
          children: [
            const Icon(Icons.info_outline, size: 24, color: AppColors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
          ],
        ),
        backgroundColor: Colors.orange,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      );

  CustomSnackBar.warning({super.key, required String text})
    : super(
        content: Row(
          children: [
            const Icon(Icons.warning_amber, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14, color: AppColors.black),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orangeAccent,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      );

  CustomSnackBar.error({super.key, required String text})
    : super(
        content: Row(
          children: [
            const Icon(Icons.close, size: 24, color: AppColors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14, color: AppColors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.red,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      );
}
