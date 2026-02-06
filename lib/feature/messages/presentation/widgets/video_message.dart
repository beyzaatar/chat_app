import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class VideoMessage extends StatelessWidget {
  const VideoMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&h=450&fit=crop",
              ),
            ),
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: colors.primaryButton,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow, size: 16, color: colors.buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
