import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/feature/call/data/call_permissions.dart';
import 'package:chat_app/feature/call/data/services/call_service.dart';
import 'package:chat_app/feature/chats/application/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/chat_input_field.dart';

class MessagesPage extends ConsumerStatefulWidget {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;

  const MessagesPage({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
  });

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  bool _hasMarkedAsRead = false;
  Map<String, dynamic>? _otherUserProfile;
  final _callService = CallService();

  Future<void> _startCall({required bool isVideo}) async {
    final hasPermission = await requestCallPermissions(isVideo);
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mikrofon/kamera izni gerekiyor')),
        );
      }
      return;
    }

    try {
      final call = await _callService.initiateCall(
        calleeId: widget.otherUserId,
        type: isVideo ? CallType.video : CallType.audio,
      );

      final token = await _callService.getLiveKitToken(
        roomName: call['room_name'],
        callId: call['id'],
      );

      if (mounted) {
        context.push(
          '/call',
          extra: {
            'callId': call['id'],
            'roomName': call['room_name'],
            'token': token,
            'isVideo': isVideo,
            'callerName': widget.otherUserName,
            'callerImage': widget.otherUserAvatar,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Arama başlatılamadı: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
    _loadOtherUserProfile();
  }

  Future<void> _loadOtherUserProfile() async {
    try {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', widget.otherUserId)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _otherUserProfile = profile;
        });
      }
    } catch (e) {
      // Profil yüklenemedi
    }
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
    final activeUsersAsync = ref.watch(activeUsersProvider);
    final chatState = ref.watch(chatNotifierProvider);
    final local = AppLocalizations.of(context)!;

    // Check if other user is online
    final isOnline =
        activeUsersAsync.whenData((users) {
          return users.any((u) => u['user_id'] == widget.otherUserId);
        }).value ??
        false;

    // Kullanıcı offline olduğunda profili yeniden yükle
    ref.listen(activeUsersProvider, (previous, next) {
      final wasOnlineBefore =
          previous?.value?.any((u) => u['user_id'] == widget.otherUserId) ??
          false;
      final isOnlineNow =
          next.value?.any((u) => u['user_id'] == widget.otherUserId) ?? false;

      // Online'dan offline'a geçtiyse profili yenile
      if (wasOnlineBefore && !isOnlineNow) {
        _loadOtherUserProfile();
      }
    });

    // Get last seen time from conversation profile
    DateTime? getLastSeenTime() {
      // Önce kendi state'imizden kontrol et
      if (_otherUserProfile != null) {
        final lastSeenStr = _otherUserProfile!['last_seen_at'];
        if (lastSeenStr != null) {
          try {
            // UTC olarak parse et ve local time'a çevir
            return DateTime.parse(lastSeenStr).toLocal();
          } catch (e) {
            return null;
          }
        }
      }

      // Fallback olarak conversation listesinden kontrol et
      final conversation = chatState.conversationsWithProfiles.firstWhere((c) {
        final otherUserId = c['participant_1'] == currentUserId
            ? c['participant_2']
            : c['participant_1'];
        return otherUserId == widget.otherUserId;
      }, orElse: () => {});

      final lastSeenStr = conversation['other_user_profile']?['last_seen_at'];
      if (lastSeenStr != null) {
        try {
          // UTC olarak parse et ve local time'a çevir
          return DateTime.parse(lastSeenStr).toLocal();
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    // Get online status text
    String getOnlineStatus() {
      if (isOnline) {
        return local.t('homeOnline');
      }

      final lastSeen = getLastSeenTime();

      if (lastSeen != null) {
        final difference = DateTime.now().difference(lastSeen);

        // Negatif değer kontrolü (gelecek zaman olmamalı)
        if (difference.isNegative) {
          return '';
        }

        // 1 dakikadan az
        if (difference.inMinutes < 1) {
          return local.t('homeOnline'); // "Az önce" anlamında online göster
        }

        // 60 dakikadan az
        if (difference.inMinutes < 60) {
          return local.tp('homeMinutesAgo', {
            'count': '${difference.inMinutes}',
          });
        }

        // 24 saatten az
        if (difference.inHours < 24) {
          return local.tp('homeHoursAgo', {'count': '${difference.inHours}'});
        }

        // 7 günden az
        if (difference.inDays < 7) {
          return local.tp('homeDaysAgo', {'count': '${difference.inDays}'});
        }
      }

      return '';
    }

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.otherUserName.toUpperCase(),
                      style: TextStyle(fontSize: 16, color: colors.buttonText),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (getOnlineStatus().isNotEmpty)
                      Text(
                        getOnlineStatus(),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.buttonText.withValues(alpha: 0.8),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.local_phone, color: colors.buttonText),
              onPressed: () => _startCall(isVideo: false),
            ),
            IconButton(
              icon: Icon(Icons.videocam, color: colors.buttonText),
              onPressed: () => _startCall(isVideo: true),
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
