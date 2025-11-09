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
import 'package:kidney_admin/views/wait_time/current_wait_times_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(navMenuProvider, (prev, state) {
      if (state.keys.firstOrNull == 3 &&
          (state.values.firstOrNull?.isNotEmpty ?? false)) {
        context.go("/${state.values.first!.toLowerCase()}");
      }
    });

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
        SizedBox(width: 280, child: SideMenu()),
        // Expanded(child: _indexedStackBuilder(ref)),
        Expanded(child: navigationShell),
      ],
    );
  }
}
