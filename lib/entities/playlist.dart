import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';
import 'package:kidney_admin/entities/media.dart';

class Playlist extends Equatable {
  final String overviewTitle;
  final String overview;
  final String benefitTitle;
  final String benefits;
  final String healingTitle;
  final String healingDesc;
  final String mediaTitle;
  final Media? media;

  const Playlist({
    this.overviewTitle = "The Healing Power of Music",
    required this.overview,
    this.benefitTitle = "Benefits for Mind and Body",
    required this.benefits,
    this.healingTitle = "Creating Your Healing Playlist",
    required this.healingDesc,
    this.mediaTitle = "Begin your Healing Journey",
    this.media,
  });

  @override
  List<Object?> get props => [overview, benefits];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'overviewTitle': overviewTitle,
      'overview': overview,
      'benefitTitle': benefitTitle,
      'benefits': benefits,
      'healingTitle': healingTitle,
      'healingDesc': healingDesc,
      'mediaTitle': mediaTitle,
      'media': media?.toMap(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      overview: map.getStringFromJson('overview'),
      benefits: map.getStringFromJson('benefits'),
      healingDesc: map.getStringFromJson('healingDesc'),
      media: Media.fromJson(map.getMapFromJson('media')),
    );
  }

  Playlist copyWith({
    String? overviewTitle,
    String? overview,
    String? benefitTitle,
    String? benefits,
    String? healingTitle,
    String? healingDesc,
    String? mediaTitle,
    Media? media,
  }) {
    return Playlist(
      overviewTitle: overviewTitle ?? this.overviewTitle,
      overview: overview ?? this.overview,
      benefitTitle: benefitTitle ?? this.benefitTitle,
      benefits: benefits ?? this.benefits,
      healingTitle: healingTitle ?? this.healingTitle,
      healingDesc: healingDesc ?? this.healingDesc,
      mediaTitle: mediaTitle ?? this.mediaTitle,
      media: media ?? this.media,
    );
  }
}
