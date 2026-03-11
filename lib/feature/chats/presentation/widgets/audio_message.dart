import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AudioMessage extends StatelessWidget {
  final bool isSender;

  const AudioMessage({super.key, required this.isSender});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0 * 0.75,
        vertical: 16.0 / 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: colors.primaryButton.withValues(alpha: isSender ? 1 : 0.1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.play_arrow,
            color: isSender ? colors.buttonText : colors.primaryButton,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0 / 2),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: isSender
                        ? colors.scaffoldBackground
                        : colors.primaryButton.withValues(alpha: 0.4),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: isSender
                            ? colors.scaffoldBackground
                            : colors.primaryButton,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "0.37",
            style: TextStyle(
              fontSize: 12,
              color: isSender ? colors.buttonText : null,
            ),
          ),
        ],
      ),
    );
  }
}
