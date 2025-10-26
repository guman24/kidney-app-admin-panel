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
import 'package:kidney_admin/view_models/exercise/exercise_view_model.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ExercisesScreen extends ConsumerWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseState = ref.watch(exerciseViewModel);
    final exercises = exerciseState.exercises;
    return ModalProgressHUD(
      inAsyncCall: exerciseState.deleteStatus.isLoading,
      child: Scaffold(
        appBar: DashboardAppBar(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12.0,
            children: [
              Text(
                "Exercises",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              InkWell(
                onTap: () {
                  context.goNamed(Routes.upsertExercise.name);
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
                rows: exercises.map((exercise) {
                  int sn = exercises.indexWhere((e) => e.id == exercise.id) + 1;
                  return DataRow(
                    cells: [
                      DataCell(Text(sn.toString())),
                      DataCell(
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 300,
                            minWidth: 150,
                          ),
                          child: Text(exercise.name),
                        ),
                      ),
                      DataCell(Text(exercise.username)),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 18.0,
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: exercise.status.color.withValues(
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
                                    exercise.status.name.capitalize,
                                    style: TextStyle(
                                      color: exercise.status.color,
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
                                      .read(exerciseViewModel.notifier)
                                      .updateExerciseStatus(exercise.id, value);
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
                                      .read(exerciseViewModel.notifier)
                                      .deleteExercise(exercise.id),
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
                                  Routes.upsertExercise.name,
                                  extra: exercise,
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
                                  Routes.exerciseDetails.name,
                                  extra: exercise,
                                  pathParameters: {'id': exercise.id},
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
