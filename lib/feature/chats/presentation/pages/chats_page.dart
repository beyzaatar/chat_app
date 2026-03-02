import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/feature/chats/application/providers/chat_providers.dart';
import 'package:chat_app/feature/chats/application/state/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/chat_card.dart';
import '../widgets/fill_outline_button.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key});

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(chatNotifierProvider.notifier).loadConversations(),
    );
  }

  String _getOtherParticipantName(
    Map<String, dynamic> conversation,
    AppLocalizations local,
  ) {
    return conversation['other_user_profile']?['full_name'] ??
        local.t('homeUser');
  }

  String _getOtherParticipantAvatar(Map<String, dynamic> conversation) {
    return conversation['other_user_profile']?['avatar_url'] ?? '';
  }

  String _getOtherParticipantId(Map<String, dynamic> conversation) {
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;
    if (conversation['participant_1'] == currentUserId) {
      return conversation['participant_2'];
    }
    return conversation['participant_1'];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final chatState = ref.watch(chatNotifierProvider);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colors.primaryButton,
        foregroundColor: colors.buttonText,
        automaticallyImplyLeading: false,
        title: Text(
          local.t('homeChats'),
          style: TextStyle(color: colors.buttonText),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: colors.buttonText,
            onPressed: () => context.push("/message-search"),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            color: colors.primaryButton,
            child: Row(
              children: [
                FillOutlineButton(
                  press: () {},
                  text: local.t('homeRecentMessages'),
                ),
                const SizedBox(width: 16.0),
                FillOutlineButton(
                  press: () {},
                  text: local.t('homeActive'),
                  isFilled: false,
                ),
              ],
            ),
          ),
          Expanded(
            child: chatState.status == ChatStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : chatState.status == ChatStatus.error
                ? Center(
                    child: Text(chatState.errorMessage ?? local.t('homeError')),
                  )
                : chatState.conversationsWithProfiles.isEmpty
                ? Center(child: Text(local.t('homeNoChats')))
                : ListView.builder(
                    itemCount: chatState.conversationsWithProfiles.length,
                    itemBuilder: (context, index) {
                      final conversation =
                          chatState.conversationsWithProfiles[index];
                      return ChatCard(
                        name: _getOtherParticipantName(conversation, local),
                        lastMessage: conversation['last_message'] ?? '',
                        avatarUrl: _getOtherParticipantAvatar(conversation),
                        time: conversation['last_message_at'] != null
                            ? _formatTime(
                                DateTime.parse(conversation['last_message_at']),
                                local,
                              )
                            : '',
                        press: () {
                          context.push(
                            '/messages',
                            extra: {
                              'conversationId': conversation['id'],
                              'otherUserId': _getOtherParticipantId(
                                conversation,
                              ),
                              'otherUserName': _getOtherParticipantName(
                                conversation,
                                local,
                              ),
                              'otherUserAvatar': _getOtherParticipantAvatar(
                                conversation,
                              ),
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/contact-search'),
        backgroundColor: colors.primaryButton,
        child: Icon(Icons.person_add_alt_1, color: colors.buttonText),
      ),
    );
  }

  String _formatTime(DateTime dateTime, AppLocalizations local) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inMinutes < 60) {
      return local.tp('homeMinutesAgo', {'count': '${difference.inMinutes}'});
    }
    if (difference.inHours < 24) {
      return local.tp('homeHoursAgo', {'count': '${difference.inHours}'});
    }
    return local.tp('homeDaysAgo', {'count': '${difference.inDays}'});
  }
}
