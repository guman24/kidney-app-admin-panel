import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/constants/media_assets.dart';
import 'package:kidney_admin/core/extension/sizes.dart';
import 'package:kidney_admin/core/extension/string_extension.dart';
import 'package:kidney_admin/entities/chat.dart';
import 'package:kidney_admin/entities/message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.chat,
    this.isSent = false,
    this.isGreen = false,
  });

  final bool isSent;
  final bool isGreen;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isSent
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSent)
            CircleAvatar(
              radius: 16.0,
              backgroundColor: AppColors.green,
              child: Text(
                chat.senderName.fullNameAbbr,
                style: TextStyle(fontSize: 14.0, color: AppColors.white),
              ),
              // backgroundImage: AssetImage(ImageAssets.oliverCute),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isSent
                    ? (isGreen ? Colors.green[100] : Colors.grey[200])
                    : Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(chat.message.content),
            ),
          ),
        ],
      ),
    );
  }
}
