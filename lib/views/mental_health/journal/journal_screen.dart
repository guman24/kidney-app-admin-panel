import 'package:flutter/material.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: DashboardAppBar(title: "Journal"));
  }
}
