import 'package:flutter/material.dart';
import '../../../messages/data/models/message_model.dart';
import 'text_message.dart';
import 'audio_message.dart';
import 'video_message.dart';
import 'message_status_dot.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.audio:
          return AudioMessage(message: message);
        case ChatMessageType.video:
          return const VideoMessage();
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: message.isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            const CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/women/1.jpg",
              ),
            ),
            const SizedBox(width: 16.0 / 2),
          ],
          messageContaint(message),
          if (message.isSender) MessageStatusDot(status: message.messageStatus),
        ],
      ),
    );
  }
}
