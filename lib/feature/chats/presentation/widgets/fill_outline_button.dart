import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FillOutlineButton extends StatelessWidget {
  const FillOutlineButton({
    super.key,
    this.isFilled = true,
    required this.press,
    required this.text,
  });

  final bool isFilled;
  final VoidCallback press;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: colors.buttonText),
      ),
      elevation: isFilled ? 2 : 0,
      color: isFilled ? colors.buttonText : colors.overlay,
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
          color: isFilled ? colors.primaryButton : colors.buttonText,
          fontSize: 12,
        ),
      ),
    );
  }
}
