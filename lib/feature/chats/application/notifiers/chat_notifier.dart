import 'package:chat_app/feature/chats/data/models/conversation_model.dart';
import 'package:chat_app/feature/chats/data/repositories/chat_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../state/chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super(const ChatState());

  // Konuşmaları yükle
  Future<void> loadConversations() async {
    state = state.copyWith(status: ChatStatus.loading);
    try {
      final conversations = await _repository.getConversationsWithProfiles();
      state = state.copyWith(
        status: ChatStatus.success,
        conversationsWithProfiles: conversations,
      );
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Konuşma oluştur veya mevcutsa getir
  Future<ConversationModel?> getOrCreateConversation(String otherUserId) async {
    try {
      return await _repository.getOrCreateConversation(otherUserId);
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  // Mesaj gönder
  Future<void> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    try {
      await _repository.sendMessage(
        conversationId: conversationId,
        content: content,
      );
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Mesajları okundu yap
  Future<void> markAsRead(String conversationId) async {
    try {
      await _repository.markAsRead(conversationId);
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
