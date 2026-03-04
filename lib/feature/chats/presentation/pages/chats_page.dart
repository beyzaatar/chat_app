import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/feature/chats/application/providers/chat_providers.dart';
import 'package:chat_app/feature/chats/application/state/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/chat_card.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key});

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(
      () => ref.read(chatNotifierProvider.notifier).loadConversations(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Uygulama ön plana geldiğinde konuşmaları yenile
      ref
          .read(chatNotifierProvider.notifier)
          .loadConversations(showLoading: false);
    }
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
    final activeUsersAsync = ref.watch(activeUsersProvider);
    final activeUserIds =
        activeUsersAsync
            .whenData(
              (users) => users.map((u) => u['user_id'] as String).toSet(),
            )
            .value ??
        <String>{};
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
          Expanded(
            child: chatState.status == ChatStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(chatNotifierProvider.notifier)
                          .loadConversations(showLoading: false);
                    },
                    child: chatState.status == ChatStatus.error
                        ? ListView(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: Text(
                                    chatState.errorMessage ??
                                        local.t('homeError'),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : chatState.conversationsWithProfiles.isEmpty
                        ? ListView(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: Text(local.t('homeNoChats')),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount:
                                chatState.conversationsWithProfiles.length,
                            itemBuilder: (context, index) {
                              final conversation =
                                  chatState.conversationsWithProfiles[index];
                              final otherUserId = _getOtherParticipantId(
                                conversation,
                              );
                              final isUserActive = activeUserIds.contains(
                                otherUserId,
                              );
                              return ChatCard(
                                name: _getOtherParticipantName(
                                  conversation,
                                  local,
                                ),
                                lastMessage: conversation['last_message'] ?? '',
                                avatarUrl: _getOtherParticipantAvatar(
                                  conversation,
                                ),
                                time: conversation['last_message_at'] != null
                                    ? _formatTime(
                                        DateTime.parse(
                                          conversation['last_message_at'],
                                        ).toLocal(),
                                        local,
                                      )
                                    : '',
                                unreadCount: conversation['unread_count'] ?? 0,
                                isActive: isUserActive,
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
                                      'otherUserAvatar':
                                          _getOtherParticipantAvatar(
                                            conversation,
                                          ),
                                    },
                                  );
                                },
                              );
                            },
                          ),
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

    // Negatif değer veya çok eski kontrolü
    if (difference.isNegative || difference.inDays > 365) {
      return '';
    }

    // 1 dakikadan az
    if (difference.inMinutes < 1) {
      return local.t('homeOnline'); // "Şimdi" anlamında
    }

    // 60 dakikadan az
    if (difference.inMinutes < 60) {
      return local.tp('homeMinutesAgo', {'count': '${difference.inMinutes}'});
    }

    // 24 saatten az
    if (difference.inHours < 24) {
      return local.tp('homeHoursAgo', {'count': '${difference.inHours}'});
    }

    // Her zaman için günleri göster
    return local.tp('homeDaysAgo', {'count': '${difference.inDays}'});
  }
}
