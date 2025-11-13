import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/entities/journal.dart';
import 'package:kidney_admin/view_models/journal/journal_view_model.dart';
import 'package:kidney_admin/views/shared/custom_button.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';

class JournalExercisesInput extends ConsumerStatefulWidget {
  const JournalExercisesInput({super.key});

  @override
  ConsumerState<JournalExercisesInput> createState() =>
      _JournalExercisesState();
}

class _JournalExercisesState extends ConsumerState<JournalExercisesInput> {
  late JournalExercises journalExercises;

  @override
  void initState() {
    super.initState();

    final JournalExercises? journalExercises = ref
        .read(journalViewModel)
        .journalExercises;
    if (journalExercises != null) {
      this.journalExercises = journalExercises;
    } else {
      this.journalExercises = JournalExercises(
        title: "Journaling Exercises",
        exercises: [JournalExercise(title: "", description: "")],
      );
    }
    onUpdateJournalExercises();
  }

  void onUpdateJournalExercises() {
    Future.microtask(() {
      ref
          .read(journalViewModel.notifier)
          .onChangedJournalExercises(journalExercises);
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
          Text("Journaling Exercises"),
          CustomTextInput(
            title: "Title",
            initialValue: journalExercises.title,
            onChanged: (value) {
              setState(() {
                journalExercises = journalExercises.copyWith(title: value);
              });
              onUpdateJournalExercises();
            },
          ),
          Column(
            spacing: 6.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Exercises", style: Theme.of(context).textTheme.titleSmall),
              ...List.generate(journalExercises.exercises.length, (index) {
                List<JournalExercise> exercises = List.from(
                  journalExercises.exercises,
                );
                JournalExercise journalExercise = exercises[index];
                return _buildExerciseInput(
                  onDescChanged: (value) {
                    journalExercise = journalExercise.copyWith(
                      description: value,
                    );
                    exercises[index] = journalExercise;
                    setState(() {
                      journalExercises = journalExercises.copyWith(
                        exercises: exercises,
                      );
                    });
                    onUpdateJournalExercises();
                  },
                  onTitleChanged: (value) {
                    journalExercise = journalExercise.copyWith(title: value);
                    exercises[index] = journalExercise;
                    setState(() {
                      journalExercises = journalExercises.copyWith(
                        exercises: exercises,
                      );
                    });
                    onUpdateJournalExercises();
                  },
                  initialDesc: journalExercise.description,
                  initialTitle: journalExercise.title,
                );
              }),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  label: "+ Add Exercise",
                  onTap: () {
                    setState(() {
                      journalExercises = journalExercises.copyWith(
                        exercises: [
                          ...journalExercises.exercises,
                          JournalExercise(title: "", description: ""),
                        ],
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

  Widget _buildExerciseInput({
    required Function(String?) onTitleChanged,
    required Function(String?) onDescChanged,
    String? initialTitle,
    String? initialDesc,
  }) {
    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          flex: 1,
          child: CustomTextInput(
            hint: "Title",
            initialValue: initialTitle,
            onChanged: onTitleChanged,
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomTextInput(
            hint: "Description",
            initialValue: initialDesc,
            onChanged: onDescChanged,
          ),
        ),
      ],
    );
  }
}
