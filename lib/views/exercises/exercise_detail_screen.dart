import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/constants/media_assets.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/snack_bar_extension.dart';
import 'package:kidney_admin/entities/exercise.dart';
import 'package:kidney_admin/view_models/exercise/exercise_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_image_or_video.dart';
import 'package:kidney_admin/views/shared/post_detail_user_profile_avatar.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({super.key, this.exercise, this.exerciseId});

  final Exercise? exercise;
  final String? exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 840),
        child: Scaffold(
          appBar: AppBar(title: exercise != null ? Text(exercise!.name) : null),
          body: exercise == null
              ? const Center(child: Text("No exercise found"))
              : Container(
                  decoration: BoxDecoration(color: AppColors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 18.0,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.1),
                        ),
                        child: AspectRatio(
                          aspectRatio: 2.5,
                          child: CustomImageOrVideo(media: exercise!.media),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise!.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              exercise!.benefits,
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
                                Text(
                                  exercise!.difficultyLevel,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 4.0,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(SvgAssets.time),
                                Text(
                                  exercise!.duration ?? "",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 0.5),
                      PostDetailUserProfileAvatar(username: exercise!.username),
                      Divider(thickness: 0.5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.0,
                          children: [
                            Text(
                              "Instructions",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            ...exercise!.instructions.map(
                              (e) => Row(
                                children: [
                                  Text(
                                    "${e.step}. ",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
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
                                      .read(exerciseViewModel.notifier)
                                      .updateExerciseStatus(
                                        exercise?.id ?? exerciseId ?? "",
                                        PostStatus.declined,
                                      );
                                  if (!context.mounted) return;
                                  context.showInfoSnackBar(
                                    "Exercise declined successfully",
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
                                      .read(exerciseViewModel.notifier)
                                      .updateExerciseStatus(
                                        exercise?.id ?? exerciseId ?? "",
                                        PostStatus.verified,
                                      );
                                  if (!context.mounted) return;
                                  context.showSuccessSnackBar(
                                    "Exercise approved successfully",
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
    );
  }
}
