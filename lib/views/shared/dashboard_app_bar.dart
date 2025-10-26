import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/extension/sizes.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';
import 'package:kidney_admin/views/dashboard/dashboard_screen.dart';
import 'package:kidney_admin/views/shared/menu_icon.dart';

class DashboardAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key, this.title, this.titleWidget});

  final String? title;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.white),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (!(context.isTablet || context.isDesktop))
                Center(
                  child: MenuIcon(
                    onTap: () =>
                        DashboardScreen.scaffoldKey.currentState!.openDrawer(),
                  ),
                ),
              if (titleWidget != null)
                titleWidget!
              else if (title?.isNotEmpty ?? false)
                Text(
                  title ?? "",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
              const Spacer(),
              Row(
                spacing: 12.0,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.olive.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox.square(
                        dimension: 24.0,
                        child: Icon(
                          Icons.settings_outlined,
                          color: AppColors.olive,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.olive.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox.square(
                        dimension: 24.0,
                        child: Icon(
                          CupertinoIcons.bell,
                          color: AppColors.olive,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    position: PopupMenuPosition.under,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.olive.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox.square(
                          dimension: 30.0,
                          child: Icon(
                            CupertinoIcons.person,
                            color: AppColors.olive,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                    onSelected: (value) async {
                      if (value == "logout") {
                        await ref.read(authViewModel.notifier).logout();
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'profile',
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.black),
                              SizedBox(width: 10),
                              Text('My Profile'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Text('Settings'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.black),
                              SizedBox(width: 10),
                              Text('Logout'),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
