import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';
import 'package:kidney_admin/core/utils/date_time_converter.dart';
import 'package:kidney_admin/entities/message.dart';

class Chat extends Equatable {
  final String id;
  final Message message;
  final String senderId;
  final String senderName;
  final DateTime? dateTime;

  const Chat({
    required this.id,
    required this.message,
    required this.senderId,
    required this.senderName,
    this.dateTime,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json.getStringFromJson('id'),
      message: Message.fromJson(json.getMapFromJson('message')),
      senderId: json.getStringFromJson('senderId'),
      senderName: json.getStringFromJson('senderName'),
      dateTime: DateTimeConverter().fromJson(
        json.getStringFromJson('dateTime'),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message.toJson(),
    'senderId': senderId,
    'senderName': senderName,
    'dateTime': DateTimeConverter().toJson(dateTime ?? DateTime.now()),
  };

  @override
  List<Object?> get props => [id];
}
