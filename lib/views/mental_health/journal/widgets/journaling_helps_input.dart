import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/entities/journal.dart';
import 'package:kidney_admin/view_models/journal/journal_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';

class JournalingHelpsInput extends ConsumerStatefulWidget {
  const JournalingHelpsInput({super.key});

  @override
  ConsumerState<JournalingHelpsInput> createState() =>
      _JournalingHelpsInputState();
}

class _JournalingHelpsInputState extends ConsumerState<JournalingHelpsInput> {
  late JournalHelps journalHelps;

  @override
  void initState() {
    super.initState();

    final JournalHelps? journalHelps = ref.read(journalViewModel).journalHelps;
    if (journalHelps != null) {
      this.journalHelps = journalHelps;
    } else {
      this.journalHelps = JournalHelps(
        title: "Why Journaling Helps",
        benefits: [Benefit(description: "", benefit: "")],
      );
    }

    onUpdateJournalHelps();
  }

  void onUpdateJournalHelps() {
    Future.microtask(() {
      ref.read(journalViewModel.notifier).onChangedJournalHelps(journalHelps);
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
          Text("Why Journaling Helps"),
          CustomTextInput(
            title: "Title",
            initialValue: journalHelps.title,
            onChanged: (value) {
              setState(() {
                journalHelps = journalHelps.copyWith(title: value);
              });
              onUpdateJournalHelps();
            },
          ),
          Column(
            spacing: 6.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Benefits", style: Theme.of(context).textTheme.titleSmall),
              ...List.generate(journalHelps.benefits.length, (index) {
                List<Benefit> benefits = List.from(journalHelps.benefits);
                Benefit benefit = benefits[index];
                return _benefitInput(
                  onBenefitChanged: (value) {
                    benefit = benefit.copyWith(benefit: value);
                    benefits[index] = benefit;
                    setState(() {
                      journalHelps = journalHelps.copyWith(benefits: benefits);
                    });
                    onUpdateJournalHelps();
                  },
                  onDescriptionChanged: (value) {
                    benefit = benefit.copyWith(description: value);
                    benefits[index] = benefit;
                    setState(() {
                      journalHelps = journalHelps.copyWith(benefits: benefits);
                    });
                    onUpdateJournalHelps();
                  },
                  initialBenefit: benefit.benefit,
                  initialDesc: benefit.description,
                );
              }),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  label: "+ Add Benefit",
                  onTap: () {
                    journalHelps = journalHelps.copyWith(
                      benefits: [
                        ...journalHelps.benefits,
                        Benefit(description: "", benefit: ""),
                      ],
                    );
                    setState(() {});
                    onUpdateJournalHelps();
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

  Widget _benefitInput({
    required Function(String?) onBenefitChanged,
    required Function(String?) onDescriptionChanged,
    String? initialBenefit,
    String? initialDesc,
  }) {
    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          flex: 1,
          child: CustomTextInput(
            initialValue: initialBenefit,
            hint: "Benefit",
            onChanged: onBenefitChanged,
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomTextInput(
            initialValue: initialDesc,
            hint: "Description",
            onChanged: onDescriptionChanged,
          ),
        ),
      ],
    );
  }
}
