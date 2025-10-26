import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/routes/dashboard_route.dart';
import 'package:kidney_admin/routes/routes.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';
import 'package:kidney_admin/views/auth/login_screen.dart';
import 'package:kidney_admin/views/auth/splash_screen.dart';
import 'package:kidney_admin/views/dashboard/dashboard_screen.dart';

final routerProvider = Provider((ref) {
  final authViewModelNotifier = ref.read(authViewModel.notifier);
  final authState = ref.watch(authViewModel);
  return GoRouter(
    initialLocation: Routes.dashboard.path,
    refreshListenable: authViewModelNotifier,
    routes: [
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.name,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      dashboardRoute(ref),
      // GoRoute(
      //   path: Routes.dashboard.path,
      //   name: Routes.dashboard.name,
      //   builder: (context, state) {
      //     return DashboardScreen();
      //   },
      // ),
    ],
    redirect: (context, state) {
      if (authState.authStatus == ActionStatus.loading) {
        return Routes.splash.path;
      }
      final bool isAuth = authState.authUser != null;
      final bool isAuthenticating = authState.authStatus.isLoading;
      final isOnLoginPage = state.uri.toString() == Routes.login.path;
      if (isAuthenticating) return null;
      if (!isAuth) return isOnLoginPage ? null : Routes.login.path;
      if (isAuth && isOnLoginPage) return Routes.dashboard.path;
      return null; // No redirect needed
    },
  );
});
