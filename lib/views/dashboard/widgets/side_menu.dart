import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';
import 'package:kidney_admin/core/widgets/adaptive_text.dart';
import 'package:kidney_admin/entities/oliver.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';

final navMenuProvider = NotifierProvider(() => NavMenuNotifier());

class NavMenuNotifier extends Notifier<Map<int, String?>> {
  late StatefulNavigationShell _navigationShell;

  @override
  Map<int, String?> build() {
    return {0: null};
  }

  void setNavigationShell(StatefulNavigationShell shell) {
    _navigationShell = shell;
  }

  void changeIndex(int index, {String? title}) {
    _navigationShell.goBranch(index);
    state = {index: title};
  }
}

class SideMenu extends ConsumerStatefulWidget {
  const SideMenu({super.key});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  List<Map<String, dynamic>> menuItems = [
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
      "name": "Mental Health",
      "icon_outline": CupertinoIcons.capsule,
      'icon_filled': CupertinoIcons.capsule_fill,
      'sub_menus': ["Playlist", "Inspirations", "Journal", "Mental Wellness"],
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

  void changeIndex(int index, {String? menu}) =>
      ref.read(navMenuProvider.notifier).changeIndex(index, title: menu);

  @override
  Widget build(BuildContext context) {
    final navMenuState = ref.watch(navMenuProvider);
    final int currentIndex = navMenuState.isNotEmpty
        ? navMenuState.keys.first
        : 0;
    final menuTitle = navMenuState.isNotEmpty
        ? navMenuState.values.first
        : null;

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
              return _SideMenuItem(
                onTap: (title) {
                  changeIndex(index, menu: title);
                },
                title: menu['name'],
                icon: currentIndex == index
                    ? menu['icon_filled']
                    : menu['icon_outline'],
                subMenus: menu.containsKey('sub_menus')
                    ? menu.getStringListFromJson('sub_menus')
                    : [],
                isEnabled: currentIndex == index,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SideMenuItem extends ConsumerStatefulWidget {
  const _SideMenuItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.isEnabled = false,
    this.subMenus = const [],
  });

  final String title;
  final IconData icon;
  final Function(String)? onTap;
  final List<String> subMenus;
  final bool isEnabled;

  @override
  ConsumerState<_SideMenuItem> createState() => _SideMenuItemState();
}

class _SideMenuItemState extends ConsumerState<_SideMenuItem> {
  IconData get icon => widget.icon;

  String get title => widget.title;

  List<String> get subMenus => widget.subMenus;

  bool get isEnabled => widget.isEnabled;

  Function(String)? get onTap => widget.onTap;

  bool subMenusExpanded = false;

  @override
  Widget build(BuildContext context) {
    final menuTitle = ref.watch(navMenuProvider).values.firstOrNull;
    final menuColor = isEnabled
        ? AppColors.olive
        : AppColors.black.withValues(alpha: 0.7);
    return InkWell(
      onTap: () {
        if (widget.subMenus.isEmpty) {
          onTap?.call(title);
        } else {
          /// toggle sub menus view
          // if (!subMenusExpanded) {
          //   onTap?.call(title);
          // }
          setState(() {
            subMenusExpanded = !subMenusExpanded;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16.0,
              children: [
                Icon(icon, size: 20.0, color: menuColor),
                Text(title, style: TextStyle(fontSize: 16.0, color: menuColor)),
                if (subMenus.isNotEmpty)
                  Icon(
                    subMenusExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18.0,
                    color: menuColor,
                  ),
              ],
            ),
            if (subMenus.isNotEmpty && subMenusExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: subMenus.map((subTitle) {
                    final bool isSubMenuSelected =
                        isEnabled && subTitle == menuTitle;
                    final subMenuColor = isSubMenuSelected
                        ? AppColors.olive
                        : AppColors.black.withValues(alpha: 0.7);
                    return SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isSubMenuSelected ? subMenuColor : null,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            onTap?.call(subTitle);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              subTitle,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: isSubMenuSelected
                                    ? AppColors.white
                                    : AppColors.black.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
