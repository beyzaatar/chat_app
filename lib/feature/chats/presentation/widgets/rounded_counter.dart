import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class RoundedCounter extends StatelessWidget {
  final int total;

  const RoundedCounter({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: colors.scaffoldBackground,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text("$total+", style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
