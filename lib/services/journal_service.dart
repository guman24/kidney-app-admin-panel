import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/firebase_collections.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/journal.dart';

final journalServiceProvider = AutoDisposeProvider((ref) => JournalService());

class JournalService {
  JournalService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Journal> saveJournal(Journal journal) async {
    try {
      await _firestore
          .collection(FirebaseCollections.journal)
          .doc('journal-id')
          .set(journal.toMap(), SetOptions(merge: true));
      return journal;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<Journal> fetchJournal() async {
    try {
      final query = await _firestore
          .collection(FirebaseCollections.journal)
          .get();
      if (query.docs.isNotEmpty) {
        final Journal journal = Journal.fromMap(query.docs.first.data());
        return journal;
      } else {
        throw DataException("No journal saved yet");
      }
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      print(error);
      throw DataException(error.toString());
    }
  }
}
