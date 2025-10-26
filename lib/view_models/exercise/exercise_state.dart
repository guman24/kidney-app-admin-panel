import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/exercise.dart';

class ExerciseState {
  final ActionStatus fetchExercisesStatus;
  final List<Exercise> exercises;
  final ActionStatus deleteStatus;

  const ExerciseState({
    this.fetchExercisesStatus = ActionStatus.initial,
    this.exercises = const [],
    this.deleteStatus = ActionStatus.initial,
  });

  ExerciseState copyWith({
    ActionStatus? fetchExercisesStatus,
    List<Exercise>? exercises,
    ActionStatus? deleteStatus,
  }) {
    return ExerciseState(
      fetchExercisesStatus: fetchExercisesStatus ?? this.fetchExercisesStatus,
      exercises: exercises ?? this.exercises,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }
}
