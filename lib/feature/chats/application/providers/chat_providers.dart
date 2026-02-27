import 'package:chat_app/feature/chats/data/models/message_model.dart';
import 'package:chat_app/feature/chats/data/repositories/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
      return ref.read(chatRepositoryProvider).getMessages(conversationId);
    });
