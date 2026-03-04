import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/feature/chats/application/providers/chat_providers.dart';
import 'package:chat_app/feature/chats/application/state/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContactSearchPage extends ConsumerStatefulWidget {
  const ContactSearchPage({super.key});

  @override
  ConsumerState<ContactSearchPage> createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends ConsumerState<ContactSearchPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sayfa açılınca tüm kullanıcıları yükle
    Future.microtask(() {
      ref.read(chatNotifierProvider.notifier).searchUsers('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _startConversation(
    String otherUserId,
    String otherUserName,
    String otherUserAvatar,
  ) async {
    final conversation = await ref
        .read(chatNotifierProvider.notifier)
        .getOrCreateConversation(otherUserId);

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
    final isLoading = chatState.status == ChatStatus.loading;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colors.primaryButton,
        foregroundColor: colors.buttonText,
        iconTheme: IconThemeData(color: colors.buttonText),
        title: Text(
          local.t('homeContacts'),
          style: TextStyle(color: colors.buttonText),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            color: colors.primaryButton,
            child: TextFormField(
              controller: _searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                ref.read(chatNotifierProvider.notifier).searchUsers(value);
              },
              decoration: InputDecoration(
                fillColor: colors.buttonText,
                prefixIcon: Icon(Icons.search, color: colors.placeholder),
                hintText: local.t('homeSearchHint'),
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : chatState.searchResults.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? local.t('homeNoContacts')
                          : local.t('homeUserNotFound'),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: chatState.searchResults.length,
                    itemBuilder: (context, index) {
                      final user = chatState.searchResults[index];
                      final avatarUrl = user['avatar_url'] ?? '';
                      final fullName = user['full_name'] ?? local.t('homeUser');
                      final username = user['username'] ?? '';
                      final hasConversation = user['has_conversation'] ?? false;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(fullName),
                        subtitle: Text('@$username'),
                        trailing: hasConversation
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primaryButton.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  local.t('homeChat'),
                                  style: TextStyle(
                                    color: colors.primaryButton,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : null,
                        onTap: () =>
                            _startConversation(user['id'], fullName, avatarUrl),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
