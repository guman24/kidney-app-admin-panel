import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

enum MessageType { text, image, video, voice }

extension StringX on String {
  MessageType get typeEnum {
    if (this == "image") {
      return MessageType.image;
    } else if (this == "video") {
      return MessageType.video;
    } else if (this == "voice") {
      return MessageType.voice;
    }
    return MessageType.text;
  }
}

class Message extends Equatable {
  final MessageType type;
  final String content;

  const Message({this.type = MessageType.text, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json.getStringFromJson("content"),
      type: json.getStringFromJson('type').typeEnum,
    );
  }

  Map<String, dynamic> toJson() => {'type': type.name, 'content': content};

  @override
  List<Object?> get props => [content, type];

  String get conversationDisplayMessage {
    if (content.length <= 30) {
      return content;
    }
    // Return the first 30 characters if the content is longer than 30 characters
    return '${content.substring(0, 30)}...';
  }
}
