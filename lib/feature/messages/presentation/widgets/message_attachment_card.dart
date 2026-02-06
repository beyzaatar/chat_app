import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MessageAttachmentCard extends StatelessWidget {
  final VoidCallback press;
  final IconData iconData;
  final String title;

  const MessageAttachmentCard({
    super.key,
    required this.press,
    required this.iconData,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(16.0 / 2),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0 * 0.75),
              decoration: BoxDecoration(
                color: colors.primaryButton,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, size: 20, color: colors.scaffoldBackground),
            ),
            const SizedBox(height: 16.0 / 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: colors.textPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
