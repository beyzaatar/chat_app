import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/feature/chats/application/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/chat_input_field.dart';

class MessagesPage extends ConsumerStatefulWidget {
  final String conversationId;
  final String otherUserName;
  final String otherUserAvatar;

  const MessagesPage({
    super.key,
    required this.conversationId,
    required this.otherUserName,
    required this.otherUserAvatar,
  });

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  bool _hasMarkedAsRead = false;

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  void _markMessagesAsRead() {
    if (!_hasMarkedAsRead) {
      _hasMarkedAsRead = true;
      Future.microtask(() async {
        await ref
            .read(chatNotifierProvider.notifier)
            .markAsRead(widget.conversationId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;
    final messagesAsync = ref.watch(
      messagesStreamProvider(widget.conversationId),
    );
    final local = AppLocalizations.of(context)!;

    // Mesajlar yüklendiğinde okundu işaretle
    messagesAsync.whenData((messages) {
      if (messages.isNotEmpty) {
        _markMessagesAsRead();
      }
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop && mounted) {
          // Geri dönüş yapıldığında konuşma listesini yenile
          await Future.delayed(const Duration(milliseconds: 200));
          if (mounted) {
            ref
                .read(chatNotifierProvider.notifier)
                .loadConversations(showLoading: false);
          }
        }
      },
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: colors.primaryButton,
          foregroundColor: colors.buttonText,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              BackButton(
                color: colors.buttonText,
                onPressed: () => context.pop(),
              ),
              CircleAvatar(
                backgroundImage: widget.otherUserAvatar.isNotEmpty
                    ? NetworkImage(widget.otherUserAvatar)
                    : null,
                child: widget.otherUserAvatar.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 12.0),
              Text(
                widget.otherUserName,
                style: TextStyle(fontSize: 16, color: colors.buttonText),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.local_phone, color: colors.buttonText),
              onPressed: () => context.push("/audio-call"),
            ),
            IconButton(
              icon: Icon(Icons.videocam, color: colors.buttonText),
              onPressed: () {},
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: messagesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('${local.t('homeError')}: $e')),
                data: (messages) => messages.isEmpty
                    ? Center(child: Text(local.t('homeNoMessages')))
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final reversedIndex = messages.length - 1 - index;
                          final message = messages[reversedIndex];
                          final isSender = message.senderId == currentUserId;
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: isSender
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isSender) ...[
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundImage:
                                        widget.otherUserAvatar.isNotEmpty
                                        ? NetworkImage(widget.otherUserAvatar)
                                        : null,
                                  ),
                                  const SizedBox(width: 8.0),
                                ],
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSender
                                        ? colors.primaryButton
                                        : colors.primaryButton.withValues(
                                            alpha: 0.1,
                                          ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    message.content,
                                    style: TextStyle(
                                      color: isSender
                                          ? colors.buttonText
                                          : colors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
            ChatInputField(conversationId: widget.conversationId),
          ],
        ),
      ),
    );
  }
}
