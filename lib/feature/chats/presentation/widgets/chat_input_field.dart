import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/feature/chats/application/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'message_attachment.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatInputField({super.key, required this.conversationId});

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  bool _showAttachment = false;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    _controller.clear();
    await ref
        .read(chatNotifierProvider.notifier)
        .sendMessage(conversationId: widget.conversationId, content: content);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Mesajınızı yazın...",
                      suffixIcon: SizedBox(
                        width: 65,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => setState(
                                () => _showAttachment = !_showAttachment,
                              ),
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
                                horizontal: 8.0,
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
                      fillColor: colors.primaryButton.withValues(alpha: 0.08),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: colors.primaryButton,
                    child: Icon(Icons.send, color: colors.buttonText, size: 20),
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
