import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/entities/user.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.0,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.green.withValues(alpha: 0.07),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox.square(
              dimension: 30.0,
              child: Align(
                child: Text(
                  user.abbr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.fullName.trim().isNotEmpty ? user.fullName : "Unknown",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
            ),
            Text(
              user.email,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0),
            ),
          ],
        ),
      ],
    );
  }
}
