import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/models/message_model.dart';

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.notSent:
          return colors.dangerColor.withValues(alpha: 1);
        case MessageStatus.notView:
          return colors.textPrimary.withValues(alpha: 0.1);
        case MessageStatus.viewed:
          return colors.primaryButton.withValues(alpha: 1);
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 16.0 / 2),
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.notSent ? Icons.close : Icons.done,
        size: 12,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
