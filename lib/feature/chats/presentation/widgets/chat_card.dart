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
    this.unreadCount = 0,
  });

  final String name, lastMessage, avatarUrl, time;
  final bool isActive;
  final int unreadCount;
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
                      name.toUpperCase(),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(opacity: 0.64, child: Text(time)),
                if (unreadCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(minWidth: 20),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
