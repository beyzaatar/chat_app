import 'package:flutter/material.dart';

class SuggestedContacts extends StatelessWidget {
  const SuggestedContacts({
    super.key,
    required this.contacts,
    required this.onContactTap,
  });

  final List<Map<String, dynamic>> contacts;
  final Function(String userId, String userName, String avatarUrl) onContactTap;

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Henüz kullanıcı bulunmuyor",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Önerilenler",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(
                context,
              ).textTheme.titleSmall!.color!.withValues(alpha: 0.32),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        ...contacts.map((contact) {
          final avatarUrl = contact['avatar_url'] ?? '';
          final fullName = contact['full_name'] ?? 'Kullanıcı';
          final username = contact['username'] ?? '';
          final userId = contact['id'] ?? '';

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0 / 2,
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl.isEmpty ? const Icon(Icons.person) : null,
            ),
            title: Text(fullName),
            subtitle: username.isNotEmpty ? Text('@$username') : null,
            onTap: () => onContactTap(userId, fullName, avatarUrl),
          );
        }),
      ],
    );
  }
}
