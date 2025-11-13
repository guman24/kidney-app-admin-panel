import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/entities/journal.dart';
import 'package:kidney_admin/view_models/journal/journal_view_model.dart';
import 'package:kidney_admin/views/shared/custom_text_input.dart';

class JournalPowerWordsInput extends ConsumerStatefulWidget {
  const JournalPowerWordsInput({super.key, this.healingPowerWords});

  final HealingPowerWords? healingPowerWords;

  @override
  ConsumerState<JournalPowerWordsInput> createState() =>
      _JournalPowerWordsInputState();
}

class _JournalPowerWordsInputState
    extends ConsumerState<JournalPowerWordsInput> {
  late HealingPowerWords powerWords;

  @override
  void initState() {
    super.initState();

    final HealingPowerWords? healingPowerWords = ref
        .read(journalViewModel)
        .powerWords;
    if (healingPowerWords != null) {
      powerWords = healingPowerWords;
    } else {
      powerWords =
          widget.healingPowerWords ??
          HealingPowerWords(
            title: "The Healing Power of Words",
            paragraphs: ["", ""],
          );
    }

    onUpdateHealingWords();
  }

  void onUpdateHealingWords() {
    Future.microtask(() {
      ref
          .read(journalViewModel.notifier)
          .onChangedJournalHealingWords(powerWords);
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
          Text("Healing Power of Words"),
          CustomTextInput(
            title: "Title",
            initialValue: powerWords.title,
            onChanged: (value) {
              setState(() {
                powerWords = powerWords.copyWith(title: value);
              });
              onUpdateHealingWords();
            },
          ),
          CustomTextInput(
            title: "Paragraph 1",
            maxLines: 5,
            initialValue: powerWords.paragraphs.first,
            onChanged: (value) {
              setState(() {
                powerWords = powerWords.copyWith(
                  paragraphs: [value, powerWords.paragraphs.last],
                );
              });
              onUpdateHealingWords();
            },
          ),
          CustomTextInput(
            title: "Paragraph 2",
            maxLines: 5,
            initialValue: powerWords.paragraphs.last,
            onChanged: (value) {
              setState(() {
                powerWords = powerWords.copyWith(
                  paragraphs: [powerWords.paragraphs.first, value],
                );
              });
              onUpdateHealingWords();
            },
          ),
        ],
      ),
    );
  }
}
