import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/view_models/chat/chat_view_model.dart';
import 'package:kidney_admin/views/chat/widgets/conversation_card.dart';

class ConversationListView extends ConsumerWidget {
  const ConversationListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatViewModel);
    final conversations = chatState.conversations;
    if (conversations.isEmpty) {
      return Center(child: Text("No chats has been started yet"));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 24.0, left: 4, right: 4),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return ConversationCard(
          conversation: conversation,
          isSelected: chatState.selectedConversation?.id == conversation.id,
          onPressed: () {
            ref.read(chatViewModel.notifier).selectConversation(conversation);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10.0),
    );
  }
}
