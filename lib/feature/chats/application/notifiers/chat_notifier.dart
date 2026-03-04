import 'dart:developer';

import 'package:chat_app/feature/chats/data/models/conversation_model.dart';
import 'package:chat_app/feature/chats/data/repositories/chat_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../state/chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super(const ChatState());

  // Konuşmaları yükle
  Future<void> loadConversations({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(status: ChatStatus.loading);
    }
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
      final conversation = await _repository.getOrCreateConversation(
        otherUserId,
      );
      return conversation;
    } catch (e) {
      log('getOrCreateConversation error: $e');
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
      // Veritabanı güncellemesinin tamamlanması için kısa bir gecikme
      await Future.delayed(const Duration(milliseconds: 300));
      // Konuşma listesini güncelle (loading göstermeden)
      await loadConversations(showLoading: false);
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> searchUsers(String query) async {
    state = state.copyWith(status: ChatStatus.loading);
    try {
      final results = await _repository.searchUsers(query);
      state = state.copyWith(
        status: ChatStatus.success,
        searchResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
