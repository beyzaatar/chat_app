import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/chat_model.dart';
import '../widgets/chat_card.dart';
import '../widgets/fill_outline_button.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

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
        title: Text("Sohbetler", style: TextStyle(color: colors.buttonText)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: colors.buttonText,
            onPressed: () {
              context.push("/message-search");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            color: colors.primaryButton,
            child: Row(
              children: [
                FillOutlineButton(press: () {}, text: "Son Mesajlar"),
                const SizedBox(width: 16.0),
                FillOutlineButton(press: () {}, text: "Aktif", isFilled: false),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatsData.length,
              itemBuilder: (context, index) =>
                  ChatCard(chat: chatsData[index], press: () {}),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.primaryButton,
        child: Icon(Icons.person_add_alt_1, color: colors.buttonText),
      ),
    );
  }
}
