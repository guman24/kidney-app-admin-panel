import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/inspiration.dart';

class InspirationState {
  final ActionStatus fetchStatus;
  final List<Inspiration> inspirations;
  final ActionStatus saveStatus;
  final Inspiration? editInspiration;

  const InspirationState({
    this.fetchStatus = ActionStatus.initial,
    this.inspirations = const [],
    this.saveStatus = ActionStatus.initial,
    this.editInspiration,
  });

  InspirationState copyWith({
    ActionStatus? fetchStatus,
    ActionStatus? saveStatus,
    List<Inspiration>? inspirations,
    Inspiration? editInspiration,
  }) {
    return InspirationState(
      inspirations: inspirations ?? this.inspirations,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      editInspiration: editInspiration,
    );
  }
}
