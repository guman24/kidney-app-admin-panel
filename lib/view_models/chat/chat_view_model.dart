import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/entities/chat.dart';
import 'package:kidney_admin/entities/conversation.dart';
import 'package:kidney_admin/entities/message.dart';
import 'package:kidney_admin/services/chat_service.dart';
import 'package:kidney_admin/view_models/auth/auth_view_model.dart';
import 'package:kidney_admin/view_models/chat/chat_state.dart';
import 'package:uuid/uuid.dart';

final chatViewModel = NotifierProvider(() => ChatViewModel());

class ChatViewModel extends Notifier<ChatState> {
  @override
  ChatState build() {
    listenConversations();
    return ChatState();
  }

  void selectConversation(Conversation conversation) {
    state = state.copyWith(selectedConversation: conversation);
  }

  void listenConversations() {
    final conversationsStream = ref
        .read(chatServiceProvider)
        .fetchConversations();
    conversationsStream.listen((data) {
      state = state.copyWith(conversations: data);
    });
  }

  Stream<List<Chat>> fetchChatsById(String groupId) {
    return ref.read(chatServiceProvider).fetchChatsById(groupId);
  }

  void sendMessage(Chat chat, String groupId, String userId, String username) async {
    ref.read(chatServiceProvider).sendMessage(chat, groupId, userId,username);
  }

  void searchConvoByGroupId(
    String groupId,
    String receiverId,
    String receiverName,
  ) {
    // search if there is convo created already
    final List<Conversation> conversations = List.from(state.conversations);
    final conversation = conversations
        .where((e) => e.id == groupId)
        .firstOrNull;
    if (conversation != null) {
      state = state.copyWith(selectedConversation: conversation);
    } else {
      final currentOliver = ref.watch(authViewModel).currentOliver;
      Conversation conversation = Conversation(
        id: groupId,
        userId: receiverId,
        username: receiverName,
        senderId: currentOliver!.id,
        senderName: currentOliver.fullName,
        createdAt: DateTime.now(),
      );
      state = state.copyWith(selectedConversation: conversation);
    }
  }
}
