import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/transplant_center.dart';

class WaitTimeState {
  final ActionStatus saveStatus;
  final ActionStatus fetchStatus;
  final String? saveError;
  final String? fetchError;
  final List<TransplantCenter> transplantCenters;

  final TransplantCenter? editCenter;

  const WaitTimeState({
    this.saveStatus = ActionStatus.initial,
    this.saveError,
    this.fetchStatus = ActionStatus.initial,
    this.fetchError,
    this.transplantCenters = const [],
    this.editCenter,
  });

  WaitTimeState copyWith({
    ActionStatus? saveStatus,
    String? saveError,
    ActionStatus? fetchStatus,
    String? fetchError,
    List<TransplantCenter>? transplantCenters,
    TransplantCenter? editCenter,
  }) {
    return WaitTimeState(
      saveError: saveError ?? this.saveError,
      saveStatus: saveStatus ?? this.saveStatus,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      fetchError: fetchError ?? this.fetchError,
      transplantCenters: transplantCenters ?? this.transplantCenters,
      editCenter: editCenter,
    );
  }
}
