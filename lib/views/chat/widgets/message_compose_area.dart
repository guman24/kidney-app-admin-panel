import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/entities/chat.dart';
import 'package:kidney_admin/entities/message.dart';
import 'package:kidney_admin/entities/oliver.dart';
import 'package:kidney_admin/entities/user.dart';
import 'package:kidney_admin/view_models/chat/chat_view_model.dart';
import 'package:uuid/uuid.dart';

class MessageComposeArea extends ConsumerStatefulWidget {
  const MessageComposeArea({
    super.key,
    required this.oliver,
    required this.groupId,
    required this.userId,
    required this.username,
  });

  final Oliver oliver;
  final String groupId;
  final String userId;
  final String username;

  @override
  ConsumerState<MessageComposeArea> createState() => _MessageComposeAreaState();
}

class _MessageComposeAreaState extends ConsumerState<MessageComposeArea> {
  final TextEditingController _msgCtrl = TextEditingController();

  bool isSendEnabled = false;

  @override
  void initState() {
    super.initState();
    _msgCtrl.addListener(() {
      if (_msgCtrl.text.isNotEmpty) {
        setState(() {
          isSendEnabled = true;
        });
      } else {
        setState(() {
          isSendEnabled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          spacing: 12.0,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradient10,
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: TextFormField(
                    controller: _msgCtrl,
                    minLines: 1,
                    maxLines: 8,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    style: TextStyle(fontSize: 14.0, color: AppColors.black),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.gradient60,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12.0,
                      ),
                      hintText: 'Type message',
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.white,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),

            if (isSendEnabled)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.olive,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    try {
                      final Chat chat = Chat(
                        id: const Uuid().v4(),
                        message: Message(
                          type: MessageType.text,
                          content: _msgCtrl.text,
                        ),
                        senderId: widget.oliver.id,
                        senderName: widget.oliver.fullName,
                        dateTime: DateTime.now(),
                      );
                      ref
                          .read(chatViewModel.notifier)
                          .sendMessage(
                            chat,
                            widget.groupId,
                            widget.userId,
                            widget.username,
                          );
                    } finally {
                      _msgCtrl.clear();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: Align(
                      child: Icon(
                        Icons.send_rounded,
                        color: AppColors.white,
                        size: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            // IconButton(
            //   icon: Icon(Icons.sentiment_satisfied),
            //   onPressed: () {},
            // ),
            // IconButton(icon: Icon(Icons.attach_file), onPressed: () {}),
            // IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
