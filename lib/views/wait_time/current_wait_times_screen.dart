import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/view_models/wait_time/wait_times_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:kidney_admin/views/shared/title_with_plus_row.dart';
import 'package:kidney_admin/views/wait_time/widgets/save_wait_time_drawer.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CurrentWaitTimesScreen extends ConsumerStatefulWidget {
  const CurrentWaitTimesScreen({super.key});

  @override
  ConsumerState<CurrentWaitTimesScreen> createState() =>
      _CurrentWaitTimesScreenState();
}

class _CurrentWaitTimesScreenState
    extends ConsumerState<CurrentWaitTimesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final waitTimeState = ref.watch(waitTimesViewModel);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SaveWaitTimeDrawer(),
      appBar: DashboardAppBar(
        titleWidget: TitleWithPlusRow(
          title: "Current Wait Times",
          onPlus: () {
            _scaffoldKey.currentState!.openEndDrawer();
          },
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: waitTimeState.saveStatus.isLoading,
        child: Builder(
          builder: (context) {
            if (waitTimeState.fetchStatus.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            final transplantCenters = waitTimeState.transplantCenters;
            if (transplantCenters.isEmpty) {
              return Center(child: Text("No wait times has been listed"));
            }
            return GridView.builder(
              itemCount: transplantCenters.length,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 24.0,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 420,
                mainAxisExtent: 180,
                crossAxisSpacing: 24.0,
                mainAxisSpacing: 24.0,
              ),
              itemBuilder: (context, index) {
                final center = transplantCenters[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      decoration: BoxDecoration(color: AppColors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12,
                        children: [
                          Text(
                            center.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Text(
                            center.highlights,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Row(
                            spacing: 12.0,
                            children: [
                              Icon(Icons.location_city, color: AppColors.green),
                              Text(
                                center.location,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -12.0,
                      right: -12.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0,
                          ),
                          child: Row(
                            spacing: 16,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  ref.read(waitTimesViewModel.notifier).setEditCenter(center);
                                  _scaffoldKey.currentState!.openEndDrawer();
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.black,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  ref.read(waitTimesViewModel.notifier).deleteTransplantCenter(center.id);
                                },
                                child: Icon(Icons.delete, color: AppColors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
