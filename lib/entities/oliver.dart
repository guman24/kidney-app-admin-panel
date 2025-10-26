import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

class Oliver extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String role;

  const Oliver({
    this.id = "",
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory Oliver.fromJson(Map<String, dynamic> json) => Oliver(
    id: json.getStringFromJson('id'),
    fullName: json.getStringFromJson('fullName'),
    email: json.getStringFromJson('email'),
    role: json.getStringFromJson('role'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'role': role,
  };

  Oliver copyWith({String? id, String? fullName, String? email, String? role}) {
    return Oliver(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id];
}
