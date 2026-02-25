import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CallBg extends StatelessWidget {
  const CallBg({super.key, required this.image, required this.child});

  final Widget image;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.placeholder,
                colors.textSecondary,
                colors.textSecondary,
                colors.placeholder,
              ],
              stops: [0, 0.2, 0.5, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
