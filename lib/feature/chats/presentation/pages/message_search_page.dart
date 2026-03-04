import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/feature/chats/application/providers/chat_providers.dart';
import 'package:chat_app/feature/chats/application/state/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/search_text_field.dart';
import '../widgets/recent_search_contacts.dart';
import '../widgets/suggested_contacts.dart';

class MessageSearchPage extends ConsumerStatefulWidget {
  const MessageSearchPage({super.key});

  @override
  ConsumerState<MessageSearchPage> createState() => _MessageSearchPageState();
}

class _MessageSearchPageState extends ConsumerState<MessageSearchPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Sayfa açılınca konuşma yapılan kullanıcıları yükle
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

  void _onSearchChanged(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
    });
    ref.read(chatNotifierProvider.notifier).searchUsers(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final chatState = ref.watch(chatNotifierProvider);
    final isLoading = chatState.status == ChatStatus.loading;
    final searchResults = chatState.searchResults;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colors.primaryButton,
        foregroundColor: colors.buttonText,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.buttonText),
          onPressed: () => context.pop(),
        ),
        title: Text("Sohbetler", style: TextStyle(color: colors.buttonText)),
      ),
      body: Column(
        children: [
          SearchTextField(onChanged: _onSearchChanged),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty && _isSearching
                ? const Center(
                    child: Text(
                      "Kullanıcı bulunamadı",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        if (!_isSearching && searchResults.isNotEmpty)
                          RecentSearchContacts(
                            contacts: searchResults,
                            onContactTap: _startConversation,
                          ),
                        if (!_isSearching && searchResults.isNotEmpty)
                          const SizedBox(height: 16.0),
                        if (_isSearching || searchResults.isNotEmpty)
                          SuggestedContacts(
                            contacts: searchResults,
                            onContactTap: _startConversation,
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
