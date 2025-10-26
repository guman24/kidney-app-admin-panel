import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';
import 'package:kidney_admin/entities/message.dart';

class Conversation extends Equatable {
  final String id;
  final String senderId;
  final String userId;
  final String senderName;
  final String username;
  final Message? lastMessage;
  final bool isSeen;
  final DateTime? createdAt;

  const Conversation({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.userId,
    required this.username,
    this.isSeen = false,
    this.lastMessage,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json.getStringFromJson('id'),
      senderId: json.getStringFromJson('senderId'),
      userId: json.getStringFromJson('userId'),
      senderName: json.getStringFromJson('senderName'),
      username: json.getStringFromJson('username'),
      createdAt: json.getDateTimeOrNull('createdAt'),
      lastMessage: Message.fromJson(json.getMapFromJson('lastMessage')),
    );
  }

  Map<String, dynamic> toJson() => {
    'lastMessage': lastMessage?.toJson(),
    "id": id,
    "senderId": senderId,
    "userId": userId,
    "senderName": senderName,
    "username": username,
    "createdAt": createdAt,
  };

  @override
  List<Object?> get props => [id];
}
