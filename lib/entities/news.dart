import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

enum NewsType { news, research }

extension NewsTypeStringX on String {
  NewsType get newsTypeEnum {
    if (this == 'research') {
      return NewsType.research;
    }
    return NewsType.news;
  }
}

extension NewsTypeX on NewsType {
  String get displayName {
    if (this == NewsType.research) return "Research";
    return "News";
  }
}

class News extends Equatable {
  final String id;
  final String title;
  final String content;
  final String? description;
  final NewsType type;
  final String? url;
  final String? image;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final PostStatus status;

  const News({
    required this.id,
    required this.title,
    required this.content,
    this.description,
    this.type = NewsType.news,
    this.url,
    this.image,
    this.publishedAt,
    this.createdAt,
    this.status = PostStatus.pending,
  });

  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'image': image,
      'publishedAt': publishedAt,
      'createdAt': createdAt,
      'type': type.name,
      'status': status.name,
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map.getStringFromJson('id'),
      title: map.getStringFromJson('title'),
      description: map.getStringFromJson('description'),
      content: map.getStringFromJson('content'),
      url: map.getStringOrNullFromJson('url'),
      image: map.getStringOrNullFromJson('image'),
      publishedAt: map.getDateTimeOrNull('publishedAt'),
      createdAt: map.getDateTimeOrNull('createdAt'),
      type: map.getStringFromJson('type').newsTypeEnum,
      status: map.getStringFromJson('status').postStatusEnum,
    );
  }

  News copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    NewsType? type,
    String? url,
    String? image,
    DateTime? publishedAt,
    DateTime? createdAt,
    PostStatus? status,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      type: type ?? this.type,
      url: url ?? this.url,
      image: image ?? this.image,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
