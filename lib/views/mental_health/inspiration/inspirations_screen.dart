import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/extension/dialog_extension.dart';
import 'package:kidney_admin/view_models/inspiration/inspiration_view_model.dart';
import 'package:kidney_admin/views/mental_health/inspiration/widgets/inspiration_upsert_drawer.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:kidney_admin/views/shared/table_action_row.dart';
import 'package:kidney_admin/views/shared/title_with_plus_row.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class InspirationsScreen extends ConsumerStatefulWidget {
  const InspirationsScreen({super.key});

  @override
  ConsumerState<InspirationsScreen> createState() => _InspirationsScreenState();
}

class _InspirationsScreenState extends ConsumerState<InspirationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final inspirationState = ref.watch(inspirationsViewModel);
    return ModalProgressHUD(
      inAsyncCall:
          inspirationState.fetchStatus.isLoading ||
          inspirationState.saveStatus.isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: InspirationUpsertDrawer(),
        appBar: DashboardAppBar(
          titleWidget: TitleWithPlusRow(
            title: "Inspirations",
            onPlus: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ),
        body: SingleChildScrollView(
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
              DataColumn(label: Text("Content")),
              DataColumn(label: Text("Actions")),
            ],
            rows: inspirationState.inspirations
                .map(
                  (inspiration) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          (inspirationState.inspirations.indexOf(inspiration) +
                                  1)
                              .toString(),
                        ),
                      ),
                      DataCell(Text(inspiration.quote)),
                      DataCell(
                        TableActionRow(
                          onDelete: () {
                            context.showDeleteConfirmDialog(
                              onDelete: () {
                                ref
                                    .read(inspirationsViewModel.notifier)
                                    .deleteInspiration(inspiration.id);
                              },
                            );
                          },
                          onEdit: () {
                            ref
                                .read(inspirationsViewModel.notifier)
                                .setEditInspiration(inspiration);
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
