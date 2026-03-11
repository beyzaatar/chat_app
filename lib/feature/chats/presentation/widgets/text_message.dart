import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/feature/chats/data/models/message_model.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({super.key, required this.message, required this.isSender});

  final MessageModel message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0 * 0.75,
        vertical: 16.0 / 2,
      ),
      decoration: BoxDecoration(
        color: colors.primaryButton.withValues(alpha: isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: isSender
              ? colors.scaffoldBackground
              : Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }
}
