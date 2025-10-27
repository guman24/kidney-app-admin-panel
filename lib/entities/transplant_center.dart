import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

class TransplantCenter extends Equatable {
  final String id;
  final String center;
  final String location;
  final String highlights;
  final DateTime? createdAt;
  final PostStatus status;

  const TransplantCenter({
    required this.id,
    required this.center,
    required this.location,
    required this.highlights,
    this.createdAt,
    this.status = PostStatus.none,
  });

  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'center': center,
      'location': location,
      'highlights': highlights,
      'createdAt': createdAt,
      'status': status.name,
    };
  }

  factory TransplantCenter.fromMap(Map<String, dynamic> map) {
    return TransplantCenter(
      id: map.getStringFromJson('id'),
      center: map.getStringFromJson('center'),
      location: map.getStringFromJson('location'),
      highlights: map.getStringFromJson('highlights'),
      createdAt: map.getDateTimeOrNull('createdAt'),
      status: map.getStringFromJson('status').postStatusEnum,
    );
  }

  TransplantCenter copyWith({
    String? id,
    String? center,
    String? location,
    String? highlights,
    DateTime? createdAt,
    PostStatus? status,
  }) {
    return TransplantCenter(
      id: id ?? this.id,
      center: center ?? this.center,
      location: location ?? this.location,
      highlights: highlights ?? this.highlights,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
