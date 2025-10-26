import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

class User extends Equatable {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String dob;
  final String? profilePictureUrl;

  const User({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dob,
    this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json.getStringFromJson('id'),
      email: json.getStringFromJson('email'),
      firstName: json.getStringFromJson('firstName'),
      lastName: json.getStringFromJson('lastName'),
      dob: json.getStringFromJson('dob'),
      profilePictureUrl: json.getStringOrNullFromJson("profileImageUrl"),
    );
  }

  @override
  List<Object?> get props => [userId, email];

  /// Getters
  String get fullName => "$firstName $lastName";

  String get abbr {
    List<String> names = fullName.trim().split(' ');
    String initials = '';

    if (names.isNotEmpty) {
      initials += names[0].isNotEmpty ? names[0][0] : '';
    }
    if (names.length > 1) {
      initials += names.last.isNotEmpty ? names.last[0] : '';
    }

    return initials.toUpperCase();
  }
}
