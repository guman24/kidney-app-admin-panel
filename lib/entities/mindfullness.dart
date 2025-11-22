import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';
import 'package:kidney_admin/entities/media.dart';

class Mindfullness extends Equatable {
  final String id;
  final String name;
  final MindfullnessOverview mindfullnessOverview;
  final MindfullnessMedia mindfullnessMedia;
  final MindfullnessBenefits mindfullnessBenefits;
  final PostStatus status;

  const Mindfullness({
    required this.name,
    required this.id,
    required this.mindfullnessOverview,
    required this.mindfullnessMedia,
    required this.mindfullnessBenefits,
    this.status = PostStatus.none,
  });

  factory Mindfullness.fromJson(Map<String, dynamic> json) {
    return Mindfullness(
      id: json.getStringFromJson('id'),
      name: json.getStringFromJson('name'),
      mindfullnessOverview: MindfullnessOverview.fromJson(
        json.getMapFromJson('mindfullnessOverview'),
      ),
      mindfullnessMedia: MindfullnessMedia.fromJson(
        json.getMapFromJson('mindfullnessMedia'),
      ),
      mindfullnessBenefits: MindfullnessBenefits.fromJson(
        json.getMapFromJson('mindfullnessBenefits'),
      ),
      status: json.getStringFromJson('status').postStatusEnum,
    );
  }

  Mindfullness copyWith({
    String? id,
    String? name,
    MindfullnessOverview? meditationOverview,
    MindfullnessBenefits? meditationBenefits,
    MindfullnessMedia? meditationMedia,
    PostStatus? status,
  }) {
    return Mindfullness(
      id: id ?? this.id,
      name: name ?? this.name,
      mindfullnessOverview: meditationOverview ?? this.mindfullnessOverview,
      mindfullnessMedia: meditationMedia ?? this.mindfullnessMedia,
      mindfullnessBenefits: meditationBenefits ?? this.mindfullnessBenefits,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "mindfullnessOverview": mindfullnessOverview.toJson(),
      "mindfullnessMedia": mindfullnessMedia.toJson(),
      "mindfullnessBenefits": mindfullnessBenefits.toJson(),
      "status": status.name,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    mindfullnessBenefits,
    mindfullnessBenefits,
    mindfullnessMedia,
  ];
}

class MindfullnessOverview {
  final String title;
  final String overview;

  MindfullnessOverview({required this.title, required this.overview});

  factory MindfullnessOverview.fromJson(Map<String, dynamic> json) {
    return MindfullnessOverview(
      title: json.getStringFromJson('title'),
      overview: json.getStringFromJson('overview'),
    );
  }

  MindfullnessOverview copyWith({String? title, String? overview}) {
    return MindfullnessOverview(
      title: title ?? this.title,
      overview: overview ?? this.overview,
    );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, 'overview': overview};
  }
}

class MindfullnessMedia {
  final String title;
  final String description;
  final Media? media;

  MindfullnessMedia({
    required this.title,
    required this.description,
    this.media,
  });

  factory MindfullnessMedia.fromJson(Map<String, dynamic> json) {
    return MindfullnessMedia(
      title: json.getStringFromJson('title'),
      description: json.getStringFromJson('description'),
      media: Media.fromJson(json.getMapFromJson('media')),
    );
  }

  MindfullnessMedia copyWith({
    String? title,
    String? description,
    Media? media,
  }) {
    return MindfullnessMedia(
      title: title ?? this.title,
      description: description ?? this.description,
      media: media ?? this.media,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      'description': description,
      'media': media?.toMap(),
    };
  }
}

class MindfullnessBenefits {
  final String title;
  final List<String> benefits;

  MindfullnessBenefits({required this.title, required this.benefits});

  factory MindfullnessBenefits.fromJson(Map<String, dynamic> json) {
    return MindfullnessBenefits(
      title: json.getStringFromJson('title'),
      benefits: json.getStringListFromJson('benefits'),
    );
  }

  MindfullnessBenefits copyWith({String? title, List<String>? benefits}) {
    return MindfullnessBenefits(
      title: title ?? this.title,
      benefits: benefits ?? this.benefits,
    );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, 'benefits': benefits};
  }
}
