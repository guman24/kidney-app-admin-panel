import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/firebase_collections.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/news.dart';

final newsServiceProvider = AutoDisposeProvider((ref) => NewsService());

class NewsService {
  NewsService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<News> saveNews(News news) async {
    try {
      await _firestore
          .collection(FirebaseCollections.newsAndResearches)
          .doc(news.id)
          .set(news.toMap(), SetOptions(merge: true));
      return news;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<List<News>> fetchNews() async {
    try {
      final query = await _firestore
          .collection(FirebaseCollections.newsAndResearches)
          .get();
      final news = List<News>.from(
        query.docs.map((doc) => News.fromMap(doc.data())),
      );
      return news;
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> updateNewsStatus(String newsId, PostStatus status) async {
    try {
      await _firestore
          .collection(FirebaseCollections.newsAndResearches)
          .doc(newsId)
          .update({'status': status.name});
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<void> deleteNews(String newsId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.newsAndResearches)
          .doc(newsId)
          .delete();
    } catch (error) {
      throw DataException(error.toString());
    }
  }
}
