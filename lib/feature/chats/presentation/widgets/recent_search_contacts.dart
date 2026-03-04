import 'package:flutter/material.dart';
import 'rounded_counter.dart';

class RecentSearchContacts extends StatelessWidget {
  const RecentSearchContacts({
    super.key,
    required this.contacts,
    required this.onContactTap,
  });

  final List<Map<String, dynamic>> contacts;
  final Function(String userId, String userName, String avatarUrl) onContactTap;

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const SizedBox.shrink();
    }

    // En fazla 5 kişi göster, geri kalanları sayaç olarak
    final displayContacts = contacts.take(4).toList();
    final remainingCount = contacts.length > 4 ? contacts.length - 4 : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Son Aramalar",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(
                context,
              ).textTheme.titleSmall!.color!.withValues(alpha: 0.32),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Stack(
              children: [
                ...List.generate(
                  displayContacts.length + (remainingCount > 0 ? 1 : 0),
                  (index) {
                    if (index < displayContacts.length) {
                      final contact = displayContacts[index];
                      final avatarUrl = contact['avatar_url'] ?? '';
                      final userId = contact['id'] ?? '';
                      final fullName = contact['full_name'] ?? 'Kullanıcı';

                      return Positioned(
                        left: index * 48.0,
                        child: GestureDetector(
                          onTap: () =>
                              onContactTap(userId, fullName, avatarUrl),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: avatarUrl.isNotEmpty
                                  ? NetworkImage(avatarUrl)
                                  : null,
                              child: avatarUrl.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Positioned(
                        left: displayContacts.length * 48.0,
                        child: RoundedCounter(total: remainingCount),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
