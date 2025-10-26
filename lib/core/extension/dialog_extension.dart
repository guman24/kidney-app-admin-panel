import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';

extension DialogContextX on BuildContext {
  void showDeleteConfirmDialog({required VoidCallback onDelete}) {
    showAdaptiveDialog(
      barrierDismissible: true,
      context: this,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Are you sure?",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),

          content: Text(
            "Do you really want to delete this record? This process cannot be undone",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.gradient40,
            ),
          ),
          actions: [
            CustomButton(
              onTap: () {
                onDelete();
                Navigator.pop(context);
              },
              label: "Delete",
              bgColor: AppColors.red,
            ),
            CustomButton(
              onTap: () {
                Navigator.pop(context);
              },
              label: "Cancel",
              bgColor: AppColors.gradient20,
            ),
          ],
        );
      },
    );
  }
}
