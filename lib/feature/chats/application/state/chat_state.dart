import 'package:chat_app/feature/chats/data/models/conversation_model.dart';
import 'package:chat_app/feature/chats/data/models/message_model.dart';

enum ChatStatus { initial, loading, success, error }

class ChatState {
  final ChatStatus status;
  final List<ConversationModel> conversations;
  final List<Map<String, dynamic>> conversationsWithProfiles;
  final List<MessageModel> messages;
  final List<Map<String, dynamic>> searchResults;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.conversations = const [],
    this.conversationsWithProfiles = const [],
    this.messages = const [],
    this.searchResults = const [],
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ConversationModel>? conversations,
    List<Map<String, dynamic>>? conversationsWithProfiles,
    List<MessageModel>? messages,
    List<Map<String, dynamic>>? searchResults,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      conversationsWithProfiles:
          conversationsWithProfiles ?? this.conversationsWithProfiles,
      messages: messages ?? this.messages,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
