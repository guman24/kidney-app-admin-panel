import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/news.dart';
import 'package:kidney_admin/services/media_service.dart';
import 'package:kidney_admin/services/news_service.dart';
import 'package:kidney_admin/view_models/news/news_state.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';

final newsViewModel = NotifierProvider<NewsNotifier, NewsState>(
  () => NewsNotifier(),
);

class NewsNotifier extends Notifier<NewsState> {
  @override
  NewsState build() {
    return NewsState();
  }

  Future<void> saveNews(News news, {MediaUploadData? mediaData}) async {
    state = state.copyWith(upsertStatus: ActionStatus.loading);
    try {
      if (mediaData != null) {
        final mediaUrl = await ref
            .read(mediaServiceProvider)
            .uploadToFirebaseStorage(mediaData, "/news_images");
        if (mediaUrl == null) return;

        news = news.copyWith(image: mediaUrl);
      }

      final savedNews = await ref.read(newsServiceProvider).saveNews(news);
      final List<News> allNews = List.from(state.news);
      state = state.copyWith(
        upsertStatus: ActionStatus.success,
        news: [savedNews, ...allNews],
      );
    } on DataException catch (error) {
      state = state.copyWith(upsertStatus: ActionStatus.failed);
    } catch (error) {
      state = state.copyWith(upsertStatus: ActionStatus.failed);
    }
  }

  Future<void> fetchAllNews() async {
    try {
      final allNews = await ref.read(newsServiceProvider).fetchNews();
      state = state.copyWith(fetchStatus: ActionStatus.success, news: allNews);
    } catch (error) {
      state = state.copyWith(fetchStatus: ActionStatus.failed);
    }
  }

  Future<void> updateNewsStatus(String newsId, PostStatus status) async {
    try {
      await ref.read(newsServiceProvider).updateNewsStatus(newsId, status);
      List<News> newsList = List.from(state.news);
      int index = newsList.indexWhere((e) => e.id == newsId);
      News updatedNews = newsList[index];
      updatedNews = updatedNews.copyWith(status: status);
      newsList[index] = updatedNews;
      state = state.copyWith(news: newsList);
    } catch (error) {
      debugPrint("Could not update status of this exercise");
    }
  }

  void deleteNews(String newsId) async {
    state = state.copyWith(deleteStatus: ActionStatus.loading);
    try {
      await ref.read(newsServiceProvider).deleteNews(newsId);
      List<News> allNews = List.from(state.news);
      allNews.removeWhere((e) => e.id == newsId);
      state = state.copyWith(deleteStatus: ActionStatus.success, news: allNews);
    } catch (error) {
      state = state.copyWith(deleteStatus: ActionStatus.failed);
    }
  }
}
