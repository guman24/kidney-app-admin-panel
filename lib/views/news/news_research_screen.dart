import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/dialog_extension.dart';
import 'package:kidney_admin/core/extension/string_extension.dart';
import 'package:kidney_admin/routes/routes.dart';
import 'package:kidney_admin/view_models/news/news_view_model.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:kidney_admin/views/shared/table_action_row.dart';
import 'package:kidney_admin/views/shared/title_with_plus_row.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NewsResearchScreen extends ConsumerWidget {
  const NewsResearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsViewModel);

    return ModalProgressHUD(
      inAsyncCall: newsState.deleteStatus.isLoading,
      child: Scaffold(
        appBar: DashboardAppBar(
          titleWidget: TitleWithPlusRow(
            title: "News & Research",
            onPlus: () {
              context.goNamed(Routes.save.name);
            },
          ),
        ),
        body: SingleChildScrollView(
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
              DataColumn(
                label: Text("Image"),
                columnWidth: FixedColumnWidth(120),
              ),
              DataColumn(
                label: Center(child: Text("Title")),
                columnWidth: FixedColumnWidth(420),
              ),
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Action")),
            ],
            rows: newsState.news.map((news) {
              int sn = newsState.news.indexWhere((e) => e.id == news.id) + 1;
              return DataRow(
                cells: [
                  DataCell(Text(sn.toString())),
                  DataCell(CachedNetworkImage(imageUrl: news.image ?? "")),
                  DataCell(
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                              color: news.status.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              child: Text(
                                news.status.name.capitalize,
                                style: TextStyle(color: news.status.color),
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
                                  .read(newsViewModel.notifier)
                                  .updateNewsStatus(news.id, value);
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
                    TableActionRow(
                      onDelete: () {
                        context.showDeleteConfirmDialog(
                          onDelete: () {
                            ref
                                .read(newsViewModel.notifier)
                                .deleteNews(news.id);
                          },
                        );
                      },
                      onEdit: () {
                        context.goNamed(Routes.save.name, extra: news);
                      },
                      onView: () {},
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
