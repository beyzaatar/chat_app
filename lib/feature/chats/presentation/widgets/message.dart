import 'package:chat_app/feature/chats/data/models/message_model.dart';
import 'package:flutter/material.dart';
import 'message_status_dot.dart';
import 'text_message.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  final MessageModel message;
  final String currentUserId;

  bool get isSender => message.senderId == currentUserId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            const CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/women/1.jpg",
              ),
            ),
            const SizedBox(width: 16.0 / 2),
          ],
          TextMessage(message: message, isSender: isSender),
          if (isSender) MessageStatusDot(message: message, isSender: isSender),
        ],
      ),
    );
  }
}
