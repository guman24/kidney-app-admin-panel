import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/extension/sizes.dart';
import 'package:kidney_admin/core/extension/string_extension.dart';
import 'package:kidney_admin/entities/chat.dart';
import 'package:kidney_admin/entities/conversation.dart';
import 'package:kidney_admin/entities/oliver.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';
import 'package:kidney_admin/view_models/chat/chat_view_model.dart';
import 'package:kidney_admin/views/chat/chats_screen.dart';
import 'package:kidney_admin/views/chat/widgets/chat_bubble.dart';
import 'package:kidney_admin/views/shared/menu_icon.dart';

import 'widgets/message_compose_area.dart';

class ConversationScreen extends ConsumerWidget {
  const ConversationScreen({super.key, this.conversation});

  final Conversation? conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Oliver? currentOliver = ref.watch(authViewModel).currentOliver;

    if (conversation == null) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Visibility(
            visible: !context.isDesktop,
            child: Align(
              alignment: Alignment.centerLeft,
              child: MenuIcon(
                onTap: () => ChatsScreen.scaffoldKey.currentState?.openDrawer(),
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            spacing: 14.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.olive.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(
                  dimension: 100,
                  child: Icon(
                    CupertinoIcons.chat_bubble_text_fill,
                    color: AppColors.olive,
                    size: 30.0,
                  ),
                ),
              ),
              Text(
                "Select a contact to start a conversation",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gradient60,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(bottom: BorderSide(color: AppColors.gradient10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                if (!context.isDesktop)
                  MenuIcon(
                    onTap: () =>
                        ChatsScreen.scaffoldKey.currentState!.openDrawer(),
                  ),
                Row(
                  spacing: 12.0,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18.0,
                      child: Text(
                        conversation!.username.fullNameAbbr,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversation!.username,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          "Caregiver",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: ref
            .read(chatViewModel.notifier)
            .fetchChatsById(conversation!.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData &&
                (snapshot.data?.isNotEmpty ?? false)) {
              final List<Chat> chats = snapshot.data ?? [];
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10.0,
                ),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ChatBubble(
                    isSent: chat.senderId == currentOliver?.id,
                    chat: chat,
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  spacing: 14.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.olive.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox.square(
                        dimension: 100,
                        child: Icon(
                          CupertinoIcons.chat_bubble_text_fill,
                          color: AppColors.olive,
                          size: 30.0,
                        ),
                      ),
                    ),
                    Text(
                      "No conversation started yet",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gradient60,
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MessageComposeArea(
            oliver: currentOliver!,
            groupId: conversation!.id,
            userId: conversation!.userId,
            username: conversation!.username,
          ),
        ],
      ),
    );
  }
}
