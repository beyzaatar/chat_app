import 'package:chat_app/feature/chats/data/models/message_model.dart';
import 'package:chat_app/feature/chats/data/repositories/chat_repository.dart';
import 'package:chat_app/feature/chats/domain/services/presence_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../notifiers/chat_notifier.dart';
import '../state/chat_state.dart';

// Repository provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

// Chat notifier provider
final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((
  ref,
) {
  return ChatNotifier(ref.read(chatRepositoryProvider));
});

// Realtime mesaj stream provider
final messagesStreamProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, conversationId) {
      return Supabase.instance.client
          .from('messages')
          .stream(primaryKey: ['id'])
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true)
          .map(
            (data) => data.map((json) => MessageModel.fromJson(json)).toList(),
          );
    });

final presenceServiceProvider = Provider<PresenceService>((ref) {
  final service = PresenceService();
  ref.onDispose(() => service.dispose());
  return service;
});

final activeUsersProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(presenceServiceProvider);
  return service.trackAndListen();
});
