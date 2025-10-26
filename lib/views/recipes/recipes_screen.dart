import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/dialog_extension.dart';
import 'package:kidney_admin/core/extension/string_extension.dart';
import 'package:kidney_admin/routes/routes.dart';
import 'package:kidney_admin/view_models/recipe/recipe_view_model.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeViewModel);
    final recipes = recipeState.recipes;

    return ModalProgressHUD(
      inAsyncCall: recipeState.deleteStatus.isLoading,
      child: Scaffold(
        appBar: DashboardAppBar(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12.0,
            children: [
              Text(
                "Recipes",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              InkWell(
                onTap: () {
                  context.goNamed(Routes.upsertRecipe.name);
                },
                child: Icon(
                  CupertinoIcons.plus_circle_fill,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dividerThickness: 0.1,
                dataTextStyle: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                ),
                headingTextStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
                columns: [
                  DataColumn(label: Text("SN")),
                  DataColumn(label: Text("Title")),
                  DataColumn(label: Text("Author")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Action")),
                ],
                rows: recipes.map((recipe) {
                  int sn = recipes.indexWhere((e) => e.id == recipe.id) + 1;
                  return DataRow(
                    cells: [
                      DataCell(Text(sn.toString())),
                      DataCell(Text(recipe.name)),
                      DataCell(Text(recipe.username)),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: recipe.status.color.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 2.0,
                                  ),
                                  child: Text(
                                    recipe.status.name.capitalize,
                                    style: TextStyle(
                                      color: recipe.status.color,
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuButton(
                                position: PopupMenuPosition.under,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.more_vert, size: 18.0),
                                ),
                                onSelected: (value) {
                                  ref
                                      .read(recipeViewModel.notifier)
                                      .updateRecipeStatus(recipe.id, value);
                                },
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: PostStatus.verified,
                                      child: Text("Approve"),
                                    ),
                                    PopupMenuItem(
                                      value: PostStatus.declined,
                                      child: Text("Decline"),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 12,
                          children: [
                            InkWell(
                              onTap: () {
                                context.showDeleteConfirmDialog(
                                  onDelete: () => ref
                                      .read(recipeViewModel.notifier)
                                      .deleteRecipe(recipe.id),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  CupertinoIcons.delete,
                                  color: AppColors.gradient40,
                                  size: 18.0,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.goNamed(
                                  Routes.upsertRecipe.name,
                                  extra: recipe,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  CupertinoIcons.pen,
                                  color: AppColors.gradient40,
                                  size: 18.0,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.goNamed(
                                  Routes.recipeDetails.name,
                                  extra: recipe,
                                  pathParameters: {"id": recipe.id},
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  CupertinoIcons.eye,
                                  color: AppColors.gradient40,
                                  size: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
