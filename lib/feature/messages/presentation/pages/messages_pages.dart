import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/models/message_model.dart';
import '../widgets/message.dart';
import '../widgets/chat_input_field.dart';

class MessagesPages extends StatelessWidget {
  const MessagesPages({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colors.primaryButton,
        foregroundColor: colors.buttonText,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            BackButton(color: colors.buttonText),
            CircleAvatar(
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/women/1.jpg",
              ),
            ),
            SizedBox(width: 16.0 * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kristin Watson",
                  style: TextStyle(fontSize: 16, color: colors.buttonText),
                ),
                Text(
                  "35 dakika önce aktif",
                  style: TextStyle(fontSize: 12, color: colors.buttonText),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.local_phone, color: colors.buttonText),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam, color: colors.buttonText),
            onPressed: () {},
          ),
          const SizedBox(width: 16.0 / 2),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: demoChatMessages.length,
                itemBuilder: (context, index) =>
                    Message(message: demoChatMessages[index]),
              ),
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}
