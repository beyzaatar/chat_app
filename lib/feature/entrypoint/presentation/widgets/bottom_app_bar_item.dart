// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BottomAppBarItem extends StatelessWidget {
  const BottomAppBarItem({
    super.key,
    required this.iconLocation,
    required this.name,
    required this.isActive,
    required this.onTap,
  });

  final IconData iconLocation;
  final String name;
  final bool isActive;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconLocation,
            color: isActive ? colors.primaryButton : colors.placeholder,
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isActive ? colors.primaryButton : colors.placeholder,
            ),
          ),
        ],
      ),
    );
  }
}
