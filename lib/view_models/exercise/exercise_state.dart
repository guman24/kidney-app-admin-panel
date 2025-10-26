import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/exercise.dart';

class ExerciseState {
  final ActionStatus fetchExercisesStatus;
  final List<Exercise> exercises;
  final ActionStatus deleteStatus;
  final ActionStatus upsertStatus;

  const ExerciseState({
    this.fetchExercisesStatus = ActionStatus.initial,
    this.exercises = const [],
    this.deleteStatus = ActionStatus.initial,
    this.upsertStatus = ActionStatus.initial,
  });

  ExerciseState copyWith({
    ActionStatus? fetchExercisesStatus,
    List<Exercise>? exercises,
    ActionStatus? deleteStatus,
    ActionStatus? upsertStatus,
  }) {
    return ExerciseState(
      fetchExercisesStatus: fetchExercisesStatus ?? this.fetchExercisesStatus,
      exercises: exercises ?? this.exercises,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      upsertStatus: upsertStatus ?? this.upsertStatus,
    );
  }
}
