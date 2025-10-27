import 'package:flutter/material.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:kidney_admin/views/shared/title_with_plus_row.dart';

class CurrentWaitTimesScreen extends StatelessWidget {
  const CurrentWaitTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(
        titleWidget: TitleWithPlusRow(title: "Current Wait Times"),
      ),
    );
  }
}
