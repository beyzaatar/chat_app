import 'package:flutter/material.dart';
import 'circle_avatar_with_active_indicator.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
    required this.time,
    required this.press,
    this.isActive = false,
  });

  final String name, lastMessage, avatarUrl, time;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0 * 0.75,
        ),
        child: Row(
          children: [
            CircleAvatarWithActiveIndicator(
              image: avatarUrl.isNotEmpty ? avatarUrl : null,
              isActive: isActive,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(opacity: 0.64, child: Text(time)),
          ],
        ),
      ),
    );
  }
}
