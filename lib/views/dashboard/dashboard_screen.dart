import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/extension/sizes.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';
import 'package:kidney_admin/views/chat/chats_screen.dart';
import 'package:kidney_admin/views/dashboard/widgets/side_menu.dart';
import 'package:kidney_admin/views/exercises/exercises_screen.dart';
import 'package:kidney_admin/views/olivers/olivers_screen.dart';
import 'package:kidney_admin/views/overview/overview_screen.dart';
import 'package:kidney_admin/views/recipes/recipes_screen.dart';
import 'package:kidney_admin/views/users/users_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(shape: RoundedRectangleBorder(), child: SideMenu()),
      body: context.isDesktop || context.isTablet
          ? _desktopBuilder(ref)
          : navigationShell,
    );
  }

  Widget _desktopBuilder(WidgetRef ref) {
    return Row(
      children: [
        SizedBox(width: 250, child: SideMenu()),
        // Expanded(child: _indexedStackBuilder(ref)),
        Expanded(child: navigationShell),
      ],
    );
  }

  Widget _indexedStackBuilder(WidgetRef ref) {
    final authState = ref.watch(authViewModel);
    final role = authState.currentOliver?.role.toLowerCase();
    final navIndex = ref.watch(navMenuProvider);
    debugPrint(
      "DashboardScreen: role=$role, navIndex=$navIndex, authUser=${authState.authUser?.email} at ${DateTime.now()}",
    );

    // Define children based on role
    //todo: use this later when moderator/specialist accounts available
    final List<Widget> dashboardViews = role == "admin"
        ? [
            OverviewScreen(),
            OliversScreen(),
            ChatsScreen(),
            UsersScreen(),
            RecipesScreen(),
            ExercisesScreen(),
          ]
        : [
            OverviewScreen(),
            ChatsScreen(),
            UsersScreen(),
            RecipesScreen(),
            ExercisesScreen(),
          ];

    // Handle null authUser
    if (authState.authUser == null) {
      return Center(child: Text('No user logged in, redirecting...'));
    }

    return IndexedStack(
      index: navIndex,
      children: [
        OverviewScreen(),
        ChatsScreen(),
        UsersScreen(),
        RecipesScreen(),
        ExercisesScreen(),
      ],
    );
  }
}
