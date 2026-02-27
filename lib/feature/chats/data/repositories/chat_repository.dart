import 'package:chat_app/feature/chats/data/models/conversation_model.dart';
import 'package:chat_app/feature/chats/data/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {
  final _supabase = Supabase.instance.client;

  String get currentUserId => _supabase.auth.currentUser!.id;

  // Konuşmaları getir
  Future<List<ConversationModel>> getConversations() async {
    final response = await _supabase
        .from('conversations')
        .select()
        .or('participant_1.eq.$currentUserId,participant_2.eq.$currentUserId')
        .order('last_message_at', ascending: false);

    return (response as List)
        .map((json) => ConversationModel.fromJson(json))
        .toList();
  }

  // Konuşma oluştur veya mevcutsa getir
  Future<ConversationModel> getOrCreateConversation(String otherUserId) async {
    // Önce mevcut konuşmayı ara
    final existing = await _supabase
        .from('conversations')
        .select()
        .or(
          'and(participant_1.eq.$currentUserId,participant_2.eq.$otherUserId),and(participant_1.eq.$otherUserId,participant_2.eq.$currentUserId)',
        )
        .maybeSingle();

    if (existing != null) {
      return ConversationModel.fromJson(existing);
    }

    // Yoksa yeni oluştur
    final response = await _supabase
        .from('conversations')
        .insert({'participant_1': currentUserId, 'participant_2': otherUserId})
        .select()
        .single();

    return ConversationModel.fromJson(response);
  }

  // Mesajları getir (realtime)
  Stream<List<MessageModel>> getMessages(String conversationId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map(
          (data) => data.map((json) => MessageModel.fromJson(json)).toList(),
        );
  }

  // Mesaj gönder
  Future<void> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    await _supabase.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': currentUserId,
      'content': content,
    });

    // Son mesajı güncelle
    await _supabase
        .from('conversations')
        .update({
          'last_message': content,
          'last_message_at': DateTime.now().toIso8601String(),
        })
        .eq('id', conversationId);
  }

  // Mesajları okundu olarak işaretle
  Future<void> markAsRead(String conversationId) async {
    await _supabase
        .from('messages')
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .neq('sender_id', currentUserId);
  }
}
