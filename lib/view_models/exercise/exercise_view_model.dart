import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/entities/exercise.dart';
import 'package:kidney_admin/entities/media.dart';
import 'package:kidney_admin/services/exercise_service.dart';
import 'package:kidney_admin/services/media_service.dart';
import 'package:kidney_admin/view_models/exercise/exercise_state.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';

final exerciseViewModel = NotifierProvider(() => ExerciseViewModel());

class ExerciseViewModel extends Notifier<ExerciseState> {
  @override
  ExerciseState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchExercises();
    });
    return ExerciseState();
  }

  void saveExercise(Exercise exercise, {MediaUploadData? uploadedMedia}) async {
    state = state.copyWith(upsertStatus: ActionStatus.loading);
    try {
      if (uploadedMedia != null) {
        final mediaUrl = await ref
            .read(mediaServiceProvider)
            .uploadToFirebaseStorage(uploadedMedia, "/exercise_images");
        if (mediaUrl == null) return;
        Media media = Media(
          type: uploadedMedia.isVideo ? MediaType.video : MediaType.image,
          networkType: NetworkType.network,
          value: mediaUrl,
        );
        exercise = exercise.copyWith(media: media);
      }

      final savedRecipe = await ref
          .read(exerciseServiceProvider)
          .upsertExercise(exercise);
      final List<Exercise> allExercises = List.from(state.exercises);
      state = state.copyWith(
        upsertStatus: ActionStatus.success,
        exercises: [savedRecipe, ...allExercises],
      );
    } catch (error) {
      state = state.copyWith(upsertStatus: ActionStatus.failed);
    }
  }

  Future<void> fetchExercises() async {
    debugPrint("Fetch exercises...");
    state = state.copyWith(fetchExercisesStatus: ActionStatus.loading);
    try {
      final exercises = await ref
          .read(exerciseServiceProvider)
          .fetchExercises();
      state = state.copyWith(
        fetchExercisesStatus: ActionStatus.success,
        exercises: exercises,
      );
    } catch (error) {
      state = state.copyWith(fetchExercisesStatus: ActionStatus.failed);
    }
  }

  Future<void> updateExerciseStatus(
    String exerciseId,
    PostStatus status,
  ) async {
    try {
      await ref
          .read(exerciseServiceProvider)
          .updateExerciseStatus(exerciseId, status);
      List<Exercise> exercises = List.from(state.exercises);
      int index = exercises.indexWhere((e) => e.id == exerciseId);
      Exercise updatedExercise = exercises[index];
      updatedExercise = updatedExercise.copyWith(status: status);
      exercises[index] = updatedExercise;
      state = state.copyWith(exercises: exercises);
    } catch (error) {
      debugPrint("Could not update status of this exercise");
    }
  }

  void deleteExercise(String exerciseId) async {
    state = state.copyWith(deleteStatus: ActionStatus.loading);
    try {
      await ref.read(exerciseServiceProvider).deleteExercise(exerciseId);
      List<Exercise> exercises = List.from(state.exercises);
      exercises.removeWhere((e) => e.id == exerciseId);
      state = state.copyWith(
        deleteStatus: ActionStatus.success,
        exercises: exercises,
      );
    } catch (error) {
      state = state.copyWith(deleteStatus: ActionStatus.failed);
    }
  }
}
