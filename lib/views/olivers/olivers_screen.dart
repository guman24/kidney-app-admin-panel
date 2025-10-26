import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/view_models/olivers/olivers_view_model.dart';
import 'package:kidney_admin/views/olivers/widgets/olivers_end_drawer.dart';
import 'package:kidney_admin/views/shared/custom_table_row_cell.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:kidney_admin/views/users/widgets/user_table_action_row.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OliversScreen extends ConsumerStatefulWidget {
  const OliversScreen({super.key});

  @override
  ConsumerState<OliversScreen> createState() => _OliversScreenState();
}

class _OliversScreenState extends ConsumerState<OliversScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final olivers = ref.watch(oliversViewModel).olivers;
    return ModalProgressHUD(
      inAsyncCall: ref.watch(oliversViewModel).isLoading,
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: OliversEndDrawer(scaffoldKey: scaffoldKey),
        appBar: DashboardAppBar(title: "Olivers"),
        body: Column(
          spacing: 12.0,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 12.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.olive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  onPressed: () {
                    scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Text("+ Add New Oliver"),
                ),
              ),
            ),
            Table(
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: AppColors.black.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  children: [
                    CustomTableRowCell(label: "USER"),
                    CustomTableRowCell(label: "ROLE"),
                    CustomTableRowCell(label: "STATUS"),
                    CustomTableRowCell(label: "ACTION"),
                  ],
                ),
                ...olivers.map(
                  (oliver) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(oliver.fullName)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(oliver.role)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("Active")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UserTableActionRow(
                          onDelete: () {
                            ref
                                .read(oliversViewModel.notifier)
                                .deleteOliver(oliver.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
