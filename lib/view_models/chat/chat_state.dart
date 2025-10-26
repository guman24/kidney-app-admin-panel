import 'package:kidney_admin/entities/conversation.dart';

class ChatState {
  final List<Conversation> conversations;
  final Conversation? selectedConversation;

  ChatState({this.conversations = const [], this.selectedConversation});

  ChatState copyWith({
    List<Conversation>? conversations,
    Conversation? selectedConversation,
  }) {
    return ChatState(
      conversations: conversations ?? this.conversations,
      selectedConversation: selectedConversation ?? this.selectedConversation,
    );
  }
}
