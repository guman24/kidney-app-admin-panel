import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/journal.dart';
import 'package:kidney_admin/services/journal_service.dart';
import 'package:kidney_admin/services/media_service.dart';
import 'package:kidney_admin/view_models/journal/journal_state.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';

final journalViewModel = NotifierProvider<JournalNotifier, JournalState>(
  () => JournalNotifier(),
);

class JournalNotifier extends Notifier<JournalState> {
  @override
  JournalState build() {
    Future.microtask(() {
      fetchJournal();
    });
    return JournalState();
  }

  void onTitleChanged(String value) => state = state.copyWith(title: value);

  void onThumbnailMediaChanged(MediaUploadData? data) =>
      state = state.copyWith(thumbnailData: data);

  void onChangedJournalPrompts(JournalPrompts journalPrompts) =>
      state = state.copyWith(journalPrompts: journalPrompts);

  void onChangedJournalHelps(JournalHelps value) =>
      state = state.copyWith(journalHelps: value);

  void onChangedJournalExercises(JournalExercises value) =>
      state = state.copyWith(journalExercises: value);

  void onChangedJournalHealingWords(HealingPowerWords value) =>
      state = state.copyWith(powerWords: value);

  Future<void> saveJournal() async {
    state = state.copyWith(saveStatus: ActionStatus.loading);
    try {
      Journal journal = Journal(
        title: state.title ?? "",
        healingPowerWords: state.powerWords!,
        journalExercises: state.journalExercises!,
        journalPrompts: state.journalPrompts!,
        journalHelps: state.journalHelps!,
      );
      if (state.thumbnailData != null) {
        final thumbnailUrl = await ref
            .read(mediaServiceProvider)
            .uploadToFirebaseStorage(state.thumbnailData!, "/journals");
        journal = journal.copyWith(thumbnailImage: thumbnailUrl);
      }

      final savedJournal = await ref
          .read(journalServiceProvider)
          .saveJournal(journal);
      state = state.copyWith(
        saveStatus: ActionStatus.success,
        journal: savedJournal,
        journalExercises: journal.journalExercises,
        journalHelps: journal.journalHelps,
        journalPrompts: journal.journalPrompts,
        title: journal.title,
        powerWords: journal.healingPowerWords,
      );
    } catch (error) {
      state = state.copyWith(saveStatus: ActionStatus.failed);
    }
  }

  Future<void> fetchJournal() async {
    state = state.copyWith(fetchStatus: ActionStatus.loading);
    try {
      final journal = await ref.read(journalServiceProvider).fetchJournal();
      state = state.copyWith(
        fetchStatus: ActionStatus.success,
        journal: journal,
        journalExercises: journal.journalExercises,
        journalHelps: journal.journalHelps,
        journalPrompts: journal.journalPrompts,
        title: journal.title,
        powerWords: journal.healingPowerWords,
      );
    } catch (error) {
      state = state.copyWith(fetchStatus: ActionStatus.initial);
    }
  }
}
