import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/constants/media_assets.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/snack_bar_extension.dart';
import 'package:kidney_admin/entities/recipe.dart';
import 'package:kidney_admin/view_models/recipe/recipe_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key, this.recipe, this.recipeId});

  final Recipe? recipe;
  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (recipe == null) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 820),
          child: Scaffold(
            appBar: AppBar(),
            body: Center(child: Text("No Recipe found")),
          ),
        ),
      );
    }
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 820),
        child: Scaffold(
          appBar: AppBar(title: Text(recipe!.name)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(color: AppColors.white),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    AspectRatio(
                      aspectRatio: 2.3,
                      child: CachedNetworkImage(
                        imageUrl: recipe!.media?.value ?? "",
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, _, progress) {
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          );
                        },
                        errorWidget: (context, error, obj) {
                          return Icon(
                            CupertinoIcons.photo,
                            size: 200,
                            color: AppColors.green,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.0,
                        children: [
                          Text(
                            recipe!.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            recipe!.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        spacing: 18.0,
                        children: [
                          Row(
                            spacing: 4.0,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(SvgAssets.calorie),
                              Text("300 cal", style: TextStyle(fontSize: 12.0)),
                            ],
                          ),
                          Row(
                            spacing: 4.0,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(SvgAssets.time),
                              Text("30 min", style: TextStyle(fontSize: 12.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 0.5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        spacing: 12.0,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox.square(
                            dimension: 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: ClipOval(
                                child: Image.asset(
                                  ImageAssets.oliverCute,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                recipe!.username,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                "Nutrition Expert",
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(height: 0.8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 0.5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.0,
                        children: [
                          Text(
                            "Ingredients",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ...recipe!.ingredients.map(
                            (e) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12.0,
                              children: [
                                Expanded(
                                  child: Text(
                                    e.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                                Text(e.quantity),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 0.5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.0,
                        children: [
                          Text(
                            "Instructions",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ...recipe!.instructions.map(
                            (e) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12.0,
                              children: [
                                Text(
                                  "${e.step}.",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Expanded(
                                  child: Text(
                                    e.instruction,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 18.0,
                        children: [
                          CustomButton(
                            label: "Decline",
                            onTap: () async {
                              try {
                                await ref
                                    .read(recipeViewModel.notifier)
                                    .updateRecipeStatus(
                                      recipe?.id ?? recipeId ?? "",
                                      PostStatus.declined,
                                    );
                                if (!context.mounted) return;
                                context.showInfoSnackBar(
                                  "Recipe declined successfully",
                                );
                                context.pop();
                              } catch (error) {
                                context.showErrorSnackBar(error.toString());
                              }
                            },
                            bgColor: AppColors.red,
                          ),
                          CustomButton(
                            label: "Approve",
                            onTap: () async {
                              try {
                                await ref
                                    .read(recipeViewModel.notifier)
                                    .updateRecipeStatus(
                                      recipe?.id ?? recipeId ?? "",
                                      PostStatus.verified,
                                    );
                                if (!context.mounted) return;
                                context.showSuccessSnackBar(
                                  "Recipe approved successfully",
                                );
                                context.pop();
                              } catch (error) {
                                context.showErrorSnackBar(error.toString());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
