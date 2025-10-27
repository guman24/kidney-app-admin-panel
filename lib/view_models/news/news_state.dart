import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/news.dart';

class NewsState {
  final ActionStatus fetchStatus;
  final List<News> news;
  final ActionStatus deleteStatus;
  final ActionStatus upsertStatus;

  const NewsState({
    this.fetchStatus = ActionStatus.initial,
    this.news = const [],
    this.deleteStatus = ActionStatus.initial,
    this.upsertStatus = ActionStatus.initial,
  });

  NewsState copyWith({
    ActionStatus? fetchStatus,
    List<News>? news,
    ActionStatus? deleteStatus,
    ActionStatus? upsertStatus,
  }) {
    return NewsState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      news: news ?? this.news,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      upsertStatus: upsertStatus ?? this.upsertStatus,
    );
  }
}
