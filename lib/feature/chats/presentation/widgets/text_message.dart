import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../messages/data/models/message_model.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({super.key, this.message});

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0 * 0.75,
        vertical: 16.0 / 2,
      ),
      decoration: BoxDecoration(
        color: colors.primaryButton.withValues(
          alpha: message!.isSender ? 1 : 0.1,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message!.text,
        style: TextStyle(
          color: message!.isSender
              ? colors.scaffoldBackground
              : Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }
}
