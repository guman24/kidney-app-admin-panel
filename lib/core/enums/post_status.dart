import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';

enum PostStatus { none, pending, verified, declined }

extension PostStatusX on PostStatus {
  bool get isPending => this == PostStatus.pending;

  bool get isVerified => this == PostStatus.verified;

  bool get isDeclined => this == PostStatus.declined;

  Color get color {
    if (isPending) {
      return Colors.orangeAccent;
    } else if (isVerified) {
      return AppColors.green;
    } else if (isDeclined) {
      return AppColors.red;
    }
    return AppColors.white;
  }
}

extension PostStatusStringX on String {
  PostStatus get postStatusEnum {
    if (this == 'pending') {
      return PostStatus.pending;
    } else if (this == 'verified') {
      return PostStatus.verified;
    } else if (this == 'declined') {
      return PostStatus.declined;
    }
    return PostStatus.none;
  }
}
