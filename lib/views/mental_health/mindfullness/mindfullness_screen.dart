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
import 'package:kidney_admin/view_models/mindfullness/mindfullness_view_model.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:kidney_admin/views/shared/title_with_plus_row.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MindfullnessScreen extends ConsumerWidget {
  const MindfullnessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mindfullnessState = ref.watch(mindfullnessViewModel);
    return Scaffold(
      appBar: DashboardAppBar(
        titleWidget: TitleWithPlusRow(
          title: "Mindfullness",
          onPlus: () {
            context.goNamed(Routes.saveMindfullness.name);
          },
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: mindfullnessState.fetchStatus.isLoading,
        child: SingleChildScrollView(
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
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Action")),
            ],
            rows: mindfullnessState.mindfullnessList.map((mindfullness) {
              int sn =
                  mindfullnessState.mindfullnessList.indexWhere(
                    (e) => e.id == mindfullness.id,
                  ) +
                  1;
              return DataRow(
                cells: [
                  DataCell(Text(sn.toString())),
                  DataCell(
                    Container(
                      constraints: BoxConstraints(maxWidth: 300, minWidth: 150),
                      child: Text(mindfullness.name),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 18.0,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: mindfullness.status.color.withValues(
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
                                mindfullness.status.name.capitalize,
                                style: TextStyle(
                                  color: mindfullness.status.color,
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
                                  .read(mindfullnessViewModel.notifier)
                                  .updatePostStatus(mindfullness.id, value);
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
                                  .read(mindfullnessViewModel.notifier)
                                  .deleteMindfullness(mindfullness.id),
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
                              Routes.saveMindfullness.name,
                              extra: mindfullness,
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
                        // InkWell(
                        //   onTap: () {
                        //     context.goNamed(
                        //       Routes.exerciseDetails.name,
                        //       extra: mindfullness,
                        //       pathParameters: {'id': mindfullness.id},
                        //     );
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(2.0),
                        //     child: Icon(
                        //       CupertinoIcons.eye,
                        //       color: AppColors.gradient40,
                        //       size: 18.0,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
