import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';

class TableActionRow extends StatelessWidget {
  const TableActionRow({super.key, this.onDelete, this.onEdit, this.onView});

  final VoidCallback? onDelete;
  final VoidCallback? onView;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [
        InkWell(
          onTap: onDelete,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              CupertinoIcons.delete,
              color: AppColors.gradient40,
              size: 18.0,
            ),
          ),
        ),
        InkWell(
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              CupertinoIcons.pen,
              color: AppColors.gradient40,
              size: 18.0,
            ),
          ),
        ),
        if (onView != null)
          InkWell(
            onTap: onView,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                CupertinoIcons.eye,
                color: AppColors.gradient40,
                size: 18.0,
              ),
            ),
          ),
      ],
    );
  }
}
