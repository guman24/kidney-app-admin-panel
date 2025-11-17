import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/firebase_collections.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/inspiration.dart';

final inspirationServiceProvider = AutoDisposeProvider(
  (_) => InspirationService(),
);

class InspirationService {
  InspirationService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Inspiration> saveInspiration(Inspiration inspiration) async {
    try {
      await _firestore
          .collection(FirebaseCollections.inspirations)
          .doc(inspiration.id)
          .set(inspiration.toJson(), SetOptions(merge: true));
      return inspiration;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<List<Inspiration>> fetchInspirations() async {
    try {
      final query = await _firestore
          .collection(FirebaseCollections.inspirations)
          .orderBy("createdAt", descending: true)
          .get();
      final List<Inspiration> inspirations = List<Inspiration>.from(
        query.docs.map((doc) => Inspiration.fromJson(doc.data())),
      ).toList();
      return inspirations;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> deleteInspiration(String id) async {
    try {
      await _firestore
          .collection(FirebaseCollections.inspirations)
          .doc(id)
          .delete();
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }
}
