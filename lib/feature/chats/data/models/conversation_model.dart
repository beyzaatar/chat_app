class ConversationModel {
  final String id;
  final String participant1;
  final String participant2;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  const ConversationModel({
    required this.id,
    required this.participant1,
    required this.participant2,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      participant1: json['participant_1'] ?? '',
      participant2: json['participant_2'] ?? '',
      lastMessage: json['last_message'],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
