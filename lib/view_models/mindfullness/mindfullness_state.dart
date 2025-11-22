import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/mindfullness.dart';

class MindfullnessState {
  final ActionStatus saveStatus;
  final List<Mindfullness> mindfullnessList;
  final ActionStatus fetchStatus;
  final ActionStatus deleteStatus;

  const MindfullnessState({
    this.fetchStatus = ActionStatus.initial,
    this.saveStatus = ActionStatus.initial,
    this.deleteStatus = ActionStatus.initial,
    this.mindfullnessList = const [],
  });

  MindfullnessState copyWith({
    ActionStatus? saveStatus,
    ActionStatus? fetchStatus,
    ActionStatus? deleteStatus,
    List<Mindfullness>? mindfullnessList,
  }) {
    return MindfullnessState(
      saveStatus: saveStatus ?? this.saveStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      mindfullnessList: mindfullnessList ?? this.mindfullnessList,
    );
  }
}
