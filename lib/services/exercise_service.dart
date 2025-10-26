import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/firebase_collections.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/exercise.dart';

final exerciseServiceProvider = AutoDisposeProvider((ref) => ExerciseService());

class ExerciseService {
  ExerciseService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Exercise> upsertExercise(Exercise exercise) async {
    try {
      await _firestore
          .collection(FirebaseCollections.exercises)
          .doc(exercise.id)
          .set(exercise.toMap(), SetOptions(merge: true));
      return exercise;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<List<Exercise>> fetchExercises() async {
    try {
      final query = await _firestore
          .collection(FirebaseCollections.exercises)
          .get();
      final List<Exercise> exercises = List<Exercise>.from(
        query.docs.map((doc) => Exercise.fromJson(doc.data())),
      );
      return exercises;
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> updateExerciseStatus(
    String exerciseId,
    PostStatus status,
  ) async {
    try {
      await _firestore
          .collection(FirebaseCollections.exercises)
          .doc(exerciseId)
          .update({'status': status.name});
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> deleteExercise(String exerciseId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.exercises)
          .doc(exerciseId)
          .delete();
    } catch (error) {
      throw DataException(error.toString());
    }
  }
}
