import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';
import 'package:kidney_admin/entities/exercise.dart';
import 'package:kidney_admin/entities/news.dart';
import 'package:kidney_admin/entities/recipe.dart';
import 'package:kidney_admin/routes/routes.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';
import 'package:kidney_admin/view_models/exercise/exercise_view_model.dart';
import 'package:kidney_admin/view_models/news/news_view_model.dart';
import 'package:kidney_admin/view_models/recipe/recipe_view_model.dart';
import 'package:kidney_admin/views/chat/chats_screen.dart';
import 'package:kidney_admin/views/dashboard/dashboard_screen.dart';
import 'package:kidney_admin/views/dashboard/widgets/side_menu.dart';
import 'package:kidney_admin/views/exercises/exercise_detail_screen.dart';
import 'package:kidney_admin/views/exercises/exercises_screen.dart';
import 'package:kidney_admin/views/exercises/upsert_exercise_screen.dart';
import 'package:kidney_admin/views/news/news_research_screen.dart';
import 'package:kidney_admin/views/news/upsert_news_screen.dart';
import 'package:kidney_admin/views/olivers/olivers_screen.dart';
import 'package:kidney_admin/views/overview/overview_screen.dart';
import 'package:kidney_admin/views/recipes/upsert_recipe_screen.dart';
import 'package:kidney_admin/views/recipes/recipe_detail_screen.dart';
import 'package:kidney_admin/views/recipes/recipes_screen.dart';
import 'package:kidney_admin/views/users/users_screen.dart';
import 'package:kidney_admin/views/wait_time/current_wait_times_screen.dart';

StatefulShellRoute dashboardRoute(Ref ref) {
  // final isAdmin =
  //     ref.watch(authViewModel).currentOliver?.role.toLowerCase() == 'admin';
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      ref.read(navMenuProvider.notifier).setNavigationShell(navigationShell);
      return DashboardScreen(navigationShell: navigationShell);
    },
    branches: [
      // overview shell
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.dashboard.path,
            name: Routes.dashboard.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: OverviewScreen());
            },
          ),
        ],
      ),

      // chats shell
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.chats.path,
            name: Routes.chats.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: ChatsScreen());
            },
          ),
        ],
      ),

      // olivers shell
      // if (isAdmin)
      //   StatefulShellBranch(
      //     routes: [
      //       GoRoute(
      //         path: Routes.olivers.path,
      //         name: Routes.olivers.name,
      //         pageBuilder: (context, state) {
      //           return NoTransitionPage(child: OliversScreen());
      //         },
      //       ),
      //     ],
      //   ),

      // users shell
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.users.path,
            name: Routes.users.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: UsersScreen());
            },
          ),
        ],
      ),

      // recipes shell
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.recipes.path,
            name: Routes.recipes.name,
            pageBuilder: (context, state) {
              ref.read(recipeViewModel.notifier).fetchRecipes();
              return NoTransitionPage(child: RecipesScreen());
            },
            routes: [
              GoRoute(
                path: Routes.upsertRecipe.path,
                name: Routes.upsertRecipe.name,
                pageBuilder: (context, state) {
                  final recipe = state.extra as Recipe?;
                  return NoTransitionPage(
                    child: UpsertRecipeScreen(recipe: recipe),
                  );
                },
              ),
              GoRoute(
                path: ':id',
                name: Routes.recipeDetails.name,
                pageBuilder: (context, state) {
                  final id = state.pathParameters.getStringOrNullFromJson('id');
                  final recipe = state.extra as Recipe?;
                  return NoTransitionPage(
                    child: RecipeDetailScreen(recipeId: id, recipe: recipe),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // exercises shell
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.exercises.path,
            name: Routes.exercises.name,
            pageBuilder: (context, state) {
              ref.read(exerciseViewModel.notifier).fetchExercises();
              return NoTransitionPage(child: ExercisesScreen());
            },
            routes: [
              GoRoute(
                path: Routes.upsertExercise.path,
                name: Routes.upsertExercise.name,
                pageBuilder: (context, state) {
                  final exercise = state.extra as Exercise?;
                  return NoTransitionPage(
                    child: UpsertExerciseScreen(exercise: exercise),
                  );
                },
              ),
              GoRoute(
                path: ':id',
                name: Routes.exerciseDetails.name,
                pageBuilder: (context, state) {
                  final id = state.pathParameters.getStringOrNullFromJson('id');
                  final exercise = state.extra as Exercise?;
                  return NoTransitionPage(
                    child: ExerciseDetailScreen(
                      exerciseId: id,
                      exercise: exercise,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // news shell
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.news.path,
            name: Routes.news.name,
            pageBuilder: (context, state) {
              ref.read(newsViewModel.notifier).fetchAllNews();
              return NoTransitionPage(child: NewsResearchScreen());
            },
            routes: [
              GoRoute(
                path: Routes.save.path,
                name: Routes.save.name,
                pageBuilder: (context, state) {
                  final news = state.extra as News?;
                  return NoTransitionPage(child: UpsertNewsScreen(news: news));
                },
              ),
            ],
          ),
        ],
      ),

      // current wait times shell
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.waitTimes.path,
            name: Routes.waitTimes.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: CurrentWaitTimesScreen());
            },
          ),
        ],
      ),
    ],
  );
}
