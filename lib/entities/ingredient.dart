// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

class Ingredient extends Equatable {
  final String id;
  final String name;
  final String quantity;
  final String? imageUrl;

  const Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id];

  Ingredient copyWith({
    String? id,
    String? name,
    String? quantity,
    String? imageUrl,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json.getStringFromJson('id'),
      name: json.getStringFromJson('name'),
      quantity: json.getStringFromJson('quantity'),
      imageUrl: json.getStringOrNullFromJson('imageUrl'),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
