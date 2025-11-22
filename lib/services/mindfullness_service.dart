import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/firebase_collections.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/mindfullness.dart';

final mindfullnessServiceProvider = AutoDisposeProvider(
  (ref) => MindfullnessService(),
);

class MindfullnessService {
  MindfullnessService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Mindfullness> saveMindfullness(Mindfullness mindfullness) async {
    try {
      await _firestore
          .collection(FirebaseCollections.mindfullness)
          .doc(mindfullness.id)
          .set(mindfullness.toJson(), SetOptions(merge: true));
      return mindfullness;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<List<Mindfullness>> fetchMindfullnessList() async {
    try {
      final query = await _firestore
          .collection(FirebaseCollections.mindfullness)
          .get();
      final List<Mindfullness> mindfullnessList = List<Mindfullness>.from(
        query.docs.map((doc) => Mindfullness.fromJson(doc.data())),
      );
      return mindfullnessList;
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> updatePostStatus(
    String mindfullnessId,
    PostStatus status,
  ) async {
    try {
      await _firestore
          .collection(FirebaseCollections.mindfullness)
          .doc(mindfullnessId)
          .update({'status': status.name});
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> deleteMindfullness(String mindfullnessId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.mindfullness)
          .doc(mindfullnessId)
          .delete();
    } catch (error) {
      throw DataException(error.toString());
    }
  }
}
