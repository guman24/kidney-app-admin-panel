// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/journal.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';

class JournalState {
  final String? title;
  final MediaUploadData? thumbnailData;
  final JournalPrompts? journalPrompts;
  final JournalHelps? journalHelps;
  final JournalExercises? journalExercises;
  final HealingPowerWords? powerWords;
  final ActionStatus fetchStatus;
  final ActionStatus saveStatus;
  final Journal? journal;

  const JournalState({
    this.journalPrompts,
    this.journalHelps,
    this.journalExercises,
    this.powerWords,
    this.title,
    this.thumbnailData,
    this.fetchStatus = ActionStatus.initial,
    this.saveStatus = ActionStatus.initial,
    this.journal,
  });

  JournalState copyWith({
    String? title,
    MediaUploadData? thumbnailData,
    JournalPrompts? journalPrompts,
    JournalHelps? journalHelps,
    JournalExercises? journalExercises,
    HealingPowerWords? powerWords,
    ActionStatus? fetchStatus,
    ActionStatus? saveStatus,
    Journal? journal,
  }) {
    return JournalState(
      title: title ?? this.title,
      thumbnailData: thumbnailData ?? this.thumbnailData,
      journalPrompts: journalPrompts ?? this.journalPrompts,
      journalHelps: journalHelps ?? this.journalHelps,
      journalExercises: journalExercises ?? this.journalExercises,
      powerWords: powerWords ?? this.powerWords,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      journal: journal ?? this.journal,
    );
  }
}
