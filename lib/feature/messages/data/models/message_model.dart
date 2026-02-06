enum ChatMessageType { text, audio, image, video }

enum MessageStatus { notSent, notView, viewed }

class ChatMessage {
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;

  ChatMessage({
    this.text = '',
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
  });
}

List<ChatMessage> demoChatMessages = [
  ChatMessage(
    text: "Merhaba Sajol,",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "Selam, Nasılsın?",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    text: "",
    messageType: ChatMessageType.audio,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "",
    messageType: ChatMessageType.video,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    text: "Hata oluştu",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.notSent,
    isSender: true,
  ),
  ChatMessage(
    text: "Bu harika görünüyor!!",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "Beğenmene sevindim",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.notView,
    isSender: true,
  ),
];
