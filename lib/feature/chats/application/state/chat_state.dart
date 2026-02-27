import 'package:chat_app/feature/chats/data/models/conversation_model.dart';
import 'package:chat_app/feature/chats/data/models/message_model.dart';

enum ChatStatus { initial, loading, success, error }

class ChatState {
  final ChatStatus status;
  final List<ConversationModel> conversations;
  final List<MessageModel> messages;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.conversations = const [],
    this.messages = const [],
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ConversationModel>? conversations,
    List<MessageModel>? messages,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
