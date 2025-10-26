
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/views/dashboard/widgets/side_menu.dart';

class UserTableActionRow extends ConsumerWidget {
  const UserTableActionRow({super.key, this.onDelete, this.onChat});

  final VoidCallback? onDelete;
  final VoidCallback? onChat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [
        InkWell(
          onTap: () {
            ref.read(navMenuProvider.notifier).changeIndex(1);
            onChat?.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              CupertinoIcons.chat_bubble_2,
              color: AppColors.gradient40,
              size: 18.0,
            ),
          ),
        ),
        // InkWell(
        //   onTap: () {},
        //   child: Padding(
        //     padding: const EdgeInsets.all(2.0),
        //     child: Icon(
        //       CupertinoIcons.square_pencil,
        //       color: AppColors.gradient40,
        //       size: 18.0,
        //     ),
        //   ),
        // ),
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
      ],
    );
  }
}
