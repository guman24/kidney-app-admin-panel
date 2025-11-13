import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/entities/journal.dart';
import 'package:kidney_admin/view_models/journal/journal_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';

class JournalPromptsInput extends ConsumerStatefulWidget {
  const JournalPromptsInput({super.key});

  @override
  ConsumerState<JournalPromptsInput> createState() =>
      _JournalPromptsInputState();
}

class _JournalPromptsInputState extends ConsumerState<JournalPromptsInput> {
  late JournalPrompts journalPrompts;

  @override
  void initState() {
    super.initState();
    // init journal prompts
    final JournalPrompts? journalPrompts = ref
        .read(journalViewModel)
        .journalPrompts;
    if (journalPrompts != null) {
      this.journalPrompts = journalPrompts;
    } else {
      this.journalPrompts = JournalPrompts(
        title: "Journal Prompts",
        prompts: [""],
      );
    }
    onChangedJournalPrompts();
  }

  void onChangedJournalPrompts() {
    Future.microtask(() {
      ref
          .read(journalViewModel.notifier)
          .onChangedJournalPrompts(journalPrompts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gradient10),
        color: AppColors.white,
      ),
      child: Column(
        spacing: 12.0,
        children: [
          Text("Journal Prompts"),
          CustomTextInput(
            title: "Title",
            initialValue: journalPrompts.title,
            onChanged: (value) {
              journalPrompts = journalPrompts.copyWith(title: value);
              setState(() {});
              onChangedJournalPrompts();
            },
          ),
          Column(
            spacing: 6.0,
            children: [
              Text("Prompts"),
              ...List.generate(
                journalPrompts.prompts.length,
                (index) => CustomTextInput(
                  hint: "Prompt ${index + 1}",
                  initialValue: journalPrompts.prompts[index],
                  onChanged: (value) {
                    List<String> prompts = List.from(journalPrompts.prompts);
                    prompts[index] = value;
                    setState(() {
                      journalPrompts = journalPrompts.copyWith(
                        prompts: prompts,
                      );
                      onChangedJournalPrompts();
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  label: "+ Add Prompt",
                  onTap: () {
                    setState(() {
                      journalPrompts = journalPrompts.copyWith(
                        prompts: [...journalPrompts.prompts, ""],
                      );
                    });
                  },
                  bgColor: AppColors.cempedak,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
