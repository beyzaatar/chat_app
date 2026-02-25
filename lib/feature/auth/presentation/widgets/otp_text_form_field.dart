import 'package:chat_app/feature/auth/presentation/pages/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const OtpTextFormField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      autofocus: autofocus,
      obscureText: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: otpInputDecoration,
    );
  }
}
