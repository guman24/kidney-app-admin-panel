// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

enum MediaType { none, image, video, audio }

enum NetworkType { file, network, asset }

extension StringX on String {
  MediaType get mediaTypeEnum {
    if (this == 'image') {
      return MediaType.image;
    } else if (this == 'video') {
      return MediaType.video;
    } else if (this == 'audio') {
      return MediaType.audio;
    }
    return MediaType.none;
  }

  NetworkType get networkTypeEnum {
    if (this == 'file') {
      return NetworkType.file;
    } else if (this == 'network') {
      return NetworkType.network;
    }
    return NetworkType.asset;
  }
}

class Media extends Equatable {
  final MediaType type;
  final NetworkType networkType;
  final String value;

  const Media({
    required this.type,
    required this.networkType,
    required this.value,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      type: json.getStringFromJson('type').mediaTypeEnum,
      networkType: json.getStringFromJson('networkType').networkTypeEnum,
      value: json.getStringFromJson('value'),
    );
  }

  @override
  List<Object?> get props => [type, networkType, value];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.name,
      'networkType': networkType.name,
      'value': value,
    };
  }
}
