import 'package:flutter/material.dart';
import '../../data/models/search_constants.dart';

class SuggestedContacts extends StatelessWidget {
  const SuggestedContacts({super.key});

  @override
  Widget build(BuildContext context) {
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
        ...List.generate(
          demoContactsImage.length,
          (index) => ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0 / 2,
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(demoContactsImage[index]),
            ),
            title: const Text("Jenny Wilson"),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
