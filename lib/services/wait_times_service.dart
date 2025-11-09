import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/firebase_collections.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/transplant_center.dart';

final waitTimeServiceProvider = AutoDisposeProvider((ref) => WaitTimeService());

class WaitTimeService {
  WaitTimeService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TransplantCenter> saveTransplantCenter(TransplantCenter center) async {
    try {
      await _firestore
          .collection(FirebaseCollections.transplantCenters)
          .doc(center.id)
          .set(center.toMap(), SetOptions(merge: true));
      return center;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<List<TransplantCenter>> fetchTransplantCenters() async {
    try {
      final query = await _firestore
          .collection(FirebaseCollections.transplantCenters)
          .get();
      final transplantCenters = List<TransplantCenter>.from(
        query.docs.map((e) => TransplantCenter.fromMap(e.data())),
      );
      return transplantCenters;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> deleteTransplantCenter(String id) async {
    try {
      await _firestore
          .collection(FirebaseCollections.transplantCenters)
          .doc(id)
          .delete();
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }
}
