import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/feature/auth/presentation/widgets/otp_text_form_field.dart';
import 'package:flutter/material.dart';

class OtpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<TextEditingController> controllers;
  final bool isLoading;
  final VoidCallback onVerify;
  final AppColors colors;

  const OtpForm({
    super.key,
    required this.formKey,
    required this.controllers,
    required this.isLoading,
    required this.onVerify,
    required this.colors,
  });

  @override
  OtpFormState createState() => OtpFormState();
}

class OtpFormState extends State<OtpForm> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            children: List.generate(6, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < 5 ? 6.0 : 0),
                  child: OtpTextFormField(
                    controller: widget.controllers[index],
                    focusNode: _focusNodes[index],
                    autofocus: index == 0,
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    },
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onVerify,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: widget.colors.primaryButton,
              foregroundColor: widget.colors.buttonText,
              minimumSize: const Size(double.infinity, 48),
              shape: const StadiumBorder(),
            ),
            child: widget.isLoading
                ? const CircularProgressIndicator()
                : const Text("Giriş Yap"),
          ),
        ],
      ),
    );
  }
}
