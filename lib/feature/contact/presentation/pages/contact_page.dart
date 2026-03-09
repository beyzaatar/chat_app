import 'dart:developer';

import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/feature/call/data/call_permissions.dart';
import 'package:chat_app/feature/call/data/services/call_service.dart';
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
    log('Starting conversation with: $otherUserId');
    final conversation = await ref
        .read(chatNotifierProvider.notifier)
        .getOrCreateConversation(otherUserId);

    log('Conversation result: $conversation');

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

  final _callService = CallService();

  Future<void> _startCall(
    BuildContext context, {
    required String calleeId,
    required String calleeName,
    required String calleeAvatar,
    required bool isVideo,
  }) async {
    // İzin kontrolü
    final hasPermission = await requestCallPermissions(isVideo);
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Mikrofon/kamera izni gerekiyor')),
        );
      }
      return;
    }

    try {
      // Aramayı başlat
      final call = await _callService.initiateCall(
        calleeId: calleeId,
        type: isVideo ? CallType.video : CallType.audio,
      );

      // Token al
      final token = await _callService.getLiveKitToken(
        roomName: call['room_name'],
        callId: call['id'],
      );

      if (mounted) {
        this.context.push(
          '/call',
          extra: {
            'callId': call['id'],
            'roomName': call['room_name'],
            'token': token,
            'isVideo': isVideo,
            'callerName': calleeName,
            'callerImage': calleeAvatar,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          this.context,
        ).showSnackBar(SnackBar(content: Text('Arama başlatılamadı: $e')));
      }
    }
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
          local.t('homeContacts'),
          style: TextStyle(color: colors.buttonText),
        ),
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
          ? Center(child: Text(local.t('homeNoUsers')))
          : ListView.builder(
              itemCount: chatState.searchResults.length,
              itemBuilder: (context, index) {
                final user = chatState.searchResults[index];
                final avatarUrl = user['avatar_url'] ?? '';
                final fullName = user['full_name'] ?? local.t('homeUser');
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

                  // ← Bunu ekleyin
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.call, color: colors.primaryButton),
                        onPressed: () => _startCall(
                          context,
                          calleeId: user['id'],
                          calleeName: fullName,
                          calleeAvatar: avatarUrl,
                          isVideo: false,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.videocam, color: colors.primaryButton),
                        onPressed: () => _startCall(
                          context,
                          calleeId: user['id'],
                          calleeName: fullName,
                          calleeAvatar: avatarUrl,
                          isVideo: true,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
