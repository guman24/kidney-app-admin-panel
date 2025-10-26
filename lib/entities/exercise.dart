// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';
import 'package:kidney_admin/entities/instruction.dart';
import 'package:kidney_admin/entities/media.dart';

class Exercise extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? userProfileUrl;
  final String name;
  final String benefits;
  final String type;
  final String difficultyLevel;
  final String? duration;
  final List<Instruction> instructions;
  final Media? media;
  final PostStatus status;

  const Exercise({
    required this.id,
    required this.userId,
    required this.username,
    this.userProfileUrl,
    required this.name,
    required this.benefits,
    required this.type,
    required this.difficultyLevel,
    this.duration,
    required this.instructions,
    this.media,
    this.status = PostStatus.none,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json.getStringFromJson('id'),
      userId: json.getStringFromJson('userId '),
      username: json.getStringFromJson('username'),
      name: json.getStringFromJson('name'),
      benefits: json.getStringFromJson('benefits'),
      type: json.getStringFromJson('type'),
      difficultyLevel: json.getStringFromJson('difficultyLevel'),
      instructions: List.from(
        json
            .getMapListFromJson('instructions')
            .map((e) => Instruction.fromJson(e)),
      ),
      media: Media.fromJson(json.getMapFromJson('media')),
      status: json.getStringFromJson('status').postStatusEnum,
    );
  }

  Exercise copyWith({
    String? id,
    String? userId,
    String? username,
    String? name,
    String? benefits,
    String? type,
    String? difficultyLevel,
    List<Instruction>? instructions,
    Media? media,
    PostStatus? status,
  }) {
    return Exercise(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      name: name ?? this.name,
      benefits: benefits ?? this.benefits,
      type: type ?? this.type,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      instructions: instructions ?? this.instructions,
      media: media ?? this.media,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'username': username,
      'userProfileUrl': userProfileUrl,
      'name': name,
      'benefits': benefits,
      'type': type,
      'difficultyLevel': difficultyLevel,
      'duration': duration,
      'instructions': instructions.map((x) => x.toMap()).toList(),
      'media': media?.toMap(),
      'status': status.name,
    };
  }
}
