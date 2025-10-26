// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';
import 'package:kidney_admin/entities/ingredient.dart';
import 'package:kidney_admin/entities/instruction.dart';

import 'media.dart';

class Recipe extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? userProfilePicture;
  final String name;
  final String description;
  final Media? media;
  final List<Ingredient> ingredients;
  final List<Instruction> instructions;
  final PostStatus status;
  final DateTime? createdAt;

  const Recipe({
    required this.id,
    required this.userId,
    required this.username,
    this.userProfilePicture,
    required this.name,
    required this.description,
    this.media,
    this.ingredients = const [],
    this.instructions = const [],
    this.status = PostStatus.none,
    this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json.getStringFromJson('id'),
      userId: json.getStringFromJson('userId'),
      username: json.getStringFromJson('username'),
      name: json.getStringFromJson('name'),
      description: json.getStringFromJson('description'),
      userProfilePicture: json.getStringOrNullFromJson('userProfilePicture'),
      media: Media.fromJson(json.getMapFromJson('media')),
      ingredients: List<Ingredient>.from(
        json
            .getMapListFromJson('ingredients')
            .map((item) => Ingredient.fromJson(item)),
      ),
      instructions: List<Instruction>.from(
        json
            .getMapListFromJson('instructions')
            .map((item) => Instruction.fromJson(item)),
      ),
      status: json.getStringFromJson('status').postStatusEnum,
      createdAt: json.getDateTimeOrNull('createdAt'),
    );
  }

  @override
  List<Object?> get props => [id];

  Recipe copyWith({
    String? id,
    String? userId,
    String? username,
    String? userProfilePicture,
    String? name,
    String? description,
    Media? media,
    List<Ingredient>? ingredients,
    List<Instruction>? instructions,
    PostStatus? status,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
      name: name ?? this.name,
      description: description ?? this.description,
      media: media ?? this.media,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'username': username,
      'userProfilePicture': userProfilePicture,
      'name': name,
      'description': description,
      'media': media?.toMap(),
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'instructions': instructions.map((x) => x.toMap()).toList(),
      'status': status.name,
      'createdAt': DateTime.now(),
    };
  }
}
