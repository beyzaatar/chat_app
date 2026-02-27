import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/feature/chats/application/providers/chat_providers.dart';
import 'package:chat_app/feature/chats/application/state/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(chatNotifierProvider.notifier).searchUsers(''),
    );
  }

  Future<void> _startConversation(
    String otherUserId,
    String otherUserName,
    String otherUserAvatar,
  ) async {
    print('Starting conversation with: $otherUserId');
    final conversation = await ref
        .read(chatNotifierProvider.notifier)
        .getOrCreateConversation(otherUserId);

    print('Conversation result: $conversation');

    if (conversation != null && mounted) {
      context.go(
        '/messages',
        extra: {
          'conversationId': conversation.id,
          'otherUserId': otherUserId,
          'otherUserName': otherUserName,
          'otherUserAvatar': otherUserAvatar,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final chatState = ref.watch(chatNotifierProvider);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colors.primaryButton,
        foregroundColor: colors.buttonText,
        title: Text("Kişiler", style: TextStyle(color: colors.buttonText)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: colors.buttonText,
            onPressed: () => context.push('/contact-search'),
          ),
        ],
      ),
      body: chatState.status == ChatStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : chatState.searchResults.isEmpty
          ? const Center(child: Text('Henüz kullanıcı yok'))
          : ListView.builder(
              itemCount: chatState.searchResults.length,
              itemBuilder: (context, index) {
                final user = chatState.searchResults[index];
                final avatarUrl = user['avatar_url'] ?? '';
                final fullName = user['full_name'] ?? 'Kullanıcı';
                final username = user['username'] ?? '';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl.isEmpty ? const Icon(Icons.person) : null,
                  ),
                  title: Text(fullName),
                  subtitle: Text('@$username'),
                  onTap: () =>
                      _startConversation(user['id'], fullName, avatarUrl),
                );
              },
            ),
    );
  }
}
