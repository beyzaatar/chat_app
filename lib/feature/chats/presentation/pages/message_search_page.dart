import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/search_text_field.dart';
import '../widgets/recent_search_contacts.dart';
import '../widgets/suggested_contacts.dart';

class MessageSearchPage extends StatelessWidget {
  const MessageSearchPage({super.key});

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
      ),
      body: Column(
        children: [
          SearchTextField(
            onChanged: (value) {
              // search
            },
          ),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  RecentSearchContacts(),
                  SizedBox(height: 16.0),
                  SuggestedContacts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
