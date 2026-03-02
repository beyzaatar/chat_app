import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CallHistoryPage extends StatelessWidget {
  const CallHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colors.primaryButton,
        foregroundColor: colors.buttonText,
        automaticallyImplyLeading: false,
        title: Text(
          local.t('homeCalls'),
          style: TextStyle(color: colors.buttonText),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: colors.buttonText,
            onPressed: () => context.push('/call-search'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // For demo
            ...List.generate(
              demoContactsImage.length,
              (index) => CallHistoryCard(
                name: "Darlene Robert",
                image: "https://randomuser.me/api/portraits/women/1.jpg",
                time: local.tp('homeMinutesAgo', {'count': '3'}),
                isActive: index.isEven,
                isOutgoingCall: index.isOdd,
                isVideoCall: index.isEven,
                press: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CallHistoryCard extends StatelessWidget {
  const CallHistoryCard({
    super.key,
    required this.name,
    required this.time,
    required this.isActive,
    required this.isVideoCall,
    required this.isOutgoingCall,
    required this.image,
    required this.press,
  });

  final String name, time, image;
  final bool isActive, isVideoCall, isOutgoingCall;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0 / 2,
      ),
      onTap: press,
      leading: CircleAvatarWithActiveIndicator(
        image: image,
        isActive: isActive,
        radius: 28,
      ),
      title: Text(name, style: TextStyle(color: colors.textPrimary)),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
        child: Row(
          children: [
            Icon(
              isOutgoingCall ? Icons.north_east : Icons.south_west,
              size: 16,
              color: isOutgoingCall ? colors.primaryButton : colors.dangerColor,
            ),
            const SizedBox(width: 16.0 / 2),
            Text(time, style: TextStyle(color: colors.textSecondary)),
          ],
        ),
      ),
      trailing: Icon(
        isVideoCall ? Icons.videocam : Icons.call,
        color: colors.primaryButton,
      ),
    );
  }
}

class CircleAvatarWithActiveIndicator extends StatelessWidget {
  const CircleAvatarWithActiveIndicator({
    super.key,
    this.image,
    this.radius = 24,
    this.isActive,
  });

  final String? image;
  final double? radius;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        CircleAvatar(radius: radius, backgroundImage: NetworkImage(image!)),
        if (isActive!)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: colors.primaryButton,
                shape: BoxShape.circle,
                border: Border.all(color: colors.scaffoldBackground, width: 3),
              ),
            ),
          ),
      ],
    );
  }
}

final List<String> demoContactsImage = [
  'https://i.postimg.cc/g25VYN7X/user-1.png',
  'https://i.postimg.cc/cCsYDjvj/user-2.png',
  'https://i.postimg.cc/sXC5W1s3/user-3.png',
  'https://i.postimg.cc/4dvVQZxV/user-4.png',
  'https://i.postimg.cc/FzDSwZcK/user-5.png',
];
