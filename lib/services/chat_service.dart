import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/entities/chat.dart';
import 'package:kidney_admin/entities/conversation.dart';

const String _collectionChats = "chats";
const String _collectionMessages = "messages";

final chatServiceProvider = AutoDisposeProvider((ref) => ChatService());

class ChatService {
  ChatService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Conversation>> fetchConversations() {
    return _firestore
        .collection(_collectionChats)
        .snapshots()
        .map(
          (data) => List<Conversation>.from(
            data.docs.map((e) => Conversation.fromJson(e.data())),
          ),
        );
  }

  Stream<List<Chat>> fetchChatsById(String groupId) {
    try {
      return _firestore
          .collection(_collectionChats)
          .doc(groupId)
          .collection(_collectionMessages)
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map(
            (snap) => List<Chat>.from(
              snap.docs.map((doc) => Chat.fromJson(doc.data())),
            ),
          );
    } catch (error) {
      throw Exception("Error fetching chats: ${error.toString()}");
    }
  }

  void sendMessage(
    Chat chat,
    String groupId,
    String userId,
    String username,
  ) async {
    try {
      Conversation conversation = Conversation(
        id: groupId,
        senderId: chat.senderId,
        senderName: chat.senderName,
        createdAt: DateTime.now(),
        lastMessage: chat.message,
        userId: userId,
        username: username,
      );
      _firestore
          .collection(_collectionChats)
          .doc(groupId)
          .set(conversation.toJson(), SetOptions(merge: true));
      _firestore
          .collection(_collectionChats)
          .doc(groupId)
          .collection(_collectionMessages)
          .doc()
          .set(chat.toJson());
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
