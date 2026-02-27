import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'message_attachment.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _showAttachment = false;

  void _updateAttachmentState() {
    setState(() {
      _showAttachment = !_showAttachment;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0 / 2),
      decoration: BoxDecoration(
        color: colors.scaffoldBackground,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            blurRadius: 32,
            color: colors.primaryButton.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.mic, color: colors.primaryButton),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 16.0 / 4),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Mesajınızı yazın...",
                            suffixIcon: SizedBox(
                              width: 65,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: _updateAttachmentState,
                                    child: Icon(
                                      Icons.attach_file,
                                      color: _showAttachment
                                          ? colors.primaryButton
                                          : Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color!
                                                .withValues(alpha: 0.64),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0 / 2,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withValues(alpha: 0.64),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            filled: true,
                            fillColor: colors.primaryButton.withValues(
                              alpha: 0.08,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5,
                              vertical: 16.0,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_showAttachment) const MessageAttachment(),
          ],
        ),
      ),
    );
  }
}
