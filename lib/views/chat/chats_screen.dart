import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/extension/sizes.dart';
import 'package:kidney_admin/view_models/chat/chat_view_model.dart';
import 'package:kidney_admin/views/chat/conversation_screen.dart';
import 'package:kidney_admin/views/chat/widgets/conversation_list_view.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatViewModel);
    return Scaffold(
      key: scaffoldKey,
      appBar: DashboardAppBar(title: "Chats"),
      drawer: Drawer(
        shape: RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConversationListView(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 10.0),
        child: context.isDesktop
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    width: 300,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border(
                        right: BorderSide(color: AppColors.gradient10),
                      ),
                    ),
                    child: ConversationListView(),
                  ),
                  Expanded(
                    child: ConversationScreen(
                      conversation: chatState.selectedConversation,
                    ),
                  ),
                ],
              )
            : ConversationScreen(conversation: chatState.selectedConversation),
      ),
    );
  }
}
