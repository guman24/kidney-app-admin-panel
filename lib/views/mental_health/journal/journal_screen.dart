import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/view_models/journal/journal_view_model.dart';
import 'package:kidney_admin/views/mental_health/journal/widgets/journal_exercises.dart';
import 'package:kidney_admin/views/mental_health/journal/widgets/journal_header_input.dart';
import 'package:kidney_admin/views/mental_health/journal/widgets/journal_power_words_input.dart';
import 'package:kidney_admin/views/mental_health/journal/widgets/journal_prompts.dart';
import 'package:kidney_admin/views/mental_health/journal/widgets/journaling_helps_input.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  @override
  Widget build(BuildContext context) {
    final journalState = ref.watch(journalViewModel);
    return ModalProgressHUD(
      inAsyncCall:
          journalState.saveStatus.isLoading ||
          journalState.saveStatus.isLoading,
      child: Scaffold(
        appBar: DashboardAppBar(
          titleWidget: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 18.0,
            children: [
              Text(
                "Love of Journaling",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              CustomButton(
                label: "Save & Publish",
                onTap: () {
                  ref.read(journalViewModel.notifier).saveJournal();
                },
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            if (journalState.fetchStatus.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if(journalState.fetchStatus.isSuccess) {
              if (constraint.maxWidth <= 640) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      JournalHeaderInput(),
                      JournalPowerWordsInput(
                        healingPowerWords: journalState.powerWords,
                      ),
                      JournalingHelpsInput(),
                      JournalExercisesInput(),
                      JournalPromptsInput(),
                    ],
                  ),
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          JournalHeaderInput(),
                          JournalPowerWordsInput(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          JournalingHelpsInput(),
                          JournalPromptsInput(),
                          JournalExercisesInput(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
