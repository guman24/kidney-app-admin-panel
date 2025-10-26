import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/view_models/chat/chat_view_model.dart';
import 'package:kidney_admin/view_models/users/users_view_model.dart';
import 'package:kidney_admin/views/shared/custom_table_row_cell.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:kidney_admin/views/users/widgets/user_info.dart';
import 'package:kidney_admin/views/users/widgets/user_table_action_row.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(usersViewModel)
        .maybeWhen(
          orElse: () => const SizedBox.shrink(),
          data: (users) {
            return Scaffold(
              appBar: DashboardAppBar(title: "Users"),
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ref
                    .watch(usersViewModel)
                    .maybeWhen(
                      data: (users) {
                        return Table(
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: AppColors.black.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                              ),
                              children: [
                                CustomTableRowCell(
                                  label: "USER",
                                  textAlign: TextAlign.start,
                                ),
                                CustomTableRowCell(label: "STATUS"),
                                CustomTableRowCell(label: "ACTION"),
                              ],
                            ),
                            ...users.map(
                              (user) => TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: UserInfo(user: user),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text("Active")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: UserTableActionRow(
                                      onChat: () {
                                        final convoGroupId =
                                            "${user.userId}-oliver-support-conversation";
                                        ref
                                            .read(chatViewModel.notifier)
                                            .searchConvoByGroupId(
                                              convoGroupId,
                                              user.userId,
                                              user.fullName,
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),
              ),
            );
          },
        );
  }
}
