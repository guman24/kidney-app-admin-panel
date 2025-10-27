import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/widgets/adaptive_text.dart';
import 'package:kidney_admin/entities/oliver.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';

final navMenuProvider = NotifierProvider(() => NavMenuNotifier());

class NavMenuNotifier extends Notifier<int> {
  late StatefulNavigationShell _navigationShell;

  @override
  int build() {
    return 0;
  }

  void setNavigationShell(StatefulNavigationShell shell) {
    _navigationShell = shell;
  }

  void changeIndex(int index) {
    _navigationShell.goBranch(index);
    state = index;
  }
}

class SideMenu extends ConsumerStatefulWidget {
  const SideMenu({super.key});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  List<Map<String, dynamic>> menuItemsMaintainer = [
    {
      "name": "Dashboard",
      "icon_outline": Icons.space_dashboard_outlined,
      'icon_filled': Icons.space_dashboard,
    },

    {
      "name": "Chats",
      "icon_outline": CupertinoIcons.chat_bubble,
      'icon_filled': CupertinoIcons.chat_bubble_fill,
    },
    {
      "name": "Users",
      "icon_outline": CupertinoIcons.person_2,
      'icon_filled': CupertinoIcons.person_2_fill,
    },
    {
      "name": "Recipes",
      "icon_outline": Icons.fastfood_outlined,
      'icon_filled': Icons.fastfood,
    },
    {
      "name": "Exercises",
      "icon_outline": Icons.run_circle_outlined,
      'icon_filled': Icons.run_circle,
    },
  ];
  List<Map<String, dynamic>> menuItemsAdmin = [
    {
      "name": "Dashboard",
      "icon_outline": Icons.space_dashboard_outlined,
      'icon_filled': Icons.space_dashboard,
    },
    // {
    //   "name": "Olivers",
    //   "icon_outline": CupertinoIcons.person_3,
    //   'icon_filled': CupertinoIcons.person_3_fill,
    // },
    {
      "name": "Chats",
      "icon_outline": CupertinoIcons.chat_bubble,
      'icon_filled': CupertinoIcons.chat_bubble_fill,
    },
    {
      "name": "Users",
      "icon_outline": CupertinoIcons.person_2,
      'icon_filled': CupertinoIcons.person_2_fill,
    },
    {
      "name": "Recipes",
      "icon_outline": Icons.fastfood_outlined,
      'icon_filled': Icons.fastfood,
    },
    {
      "name": "Exercises",
      "icon_outline": Icons.run_circle_outlined,
      'icon_filled': Icons.run_circle,
    },
    {
      "name": "News & Research",
      "icon_outline": CupertinoIcons.news,
      'icon_filled': CupertinoIcons.news_solid,
    },
    {
      "name": "Wait Times",
      "icon_outline": CupertinoIcons.clock,
      'icon_filled': CupertinoIcons.clock_fill,
    },
  ];

  void changeIndex(int index) =>
      ref.read(navMenuProvider.notifier).changeIndex(index);

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navMenuProvider);
    final Oliver? oliver = ref.watch(authViewModel).currentOliver;
    // final menuItems = oliver?.role.toLowerCase() == 'admin'
    //     ? menuItemsAdmin
    //     : menuItemsMaintainer;
    final menuItems = menuItemsAdmin;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(color: AppColors.black.withValues(alpha: 0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: .9),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24),
        child: Column(
          spacing: 18.0,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AdaptiveText(
              "Oliver - Admin",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),

            ...List.generate(menuItems.length, (index) {
              final menu = menuItems[index];
              return _sideMenuItem(
                onTap: () => changeIndex(index),
                title: menu['name'],
                icon: currentIndex == index
                    ? menu['icon_filled']
                    : menu['icon_outline'],
                isEnabled: currentIndex == index,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _sideMenuItem({
    required String title,
    required IconData icon,
    bool isEnabled = false,
    VoidCallback? onTap,
  }) {
    final menuColor = isEnabled
        ? AppColors.olive
        : AppColors.black.withValues(alpha: 0.7);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 16.0,
          children: [
            Icon(icon, size: 20.0, color: menuColor),
            Text(title, style: TextStyle(fontSize: 16.0, color: menuColor)),
          ],
        ),
      ),
    );
  }
}
