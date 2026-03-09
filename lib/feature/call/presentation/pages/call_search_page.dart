import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class CallSearchPage extends StatelessWidget {
  const CallSearchPage({super.key});

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
        iconTheme: IconThemeData(color: colors.buttonText),
        title: Text(
          local.t('homeCalls'),
          style: TextStyle(color: colors.buttonText),
        ),
      ),
      body: Column(
        children: [
          // Appbar search
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            color: colors.primaryButton,
            child: Form(
              child: TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  // search
                },
                decoration: InputDecoration(
                  fillColor: colors.buttonText,
                  prefixIcon: Icon(Icons.search, color: colors.placeholder),
                  hintText: local.t('homeSearch'),
                  hintStyle: TextStyle(color: colors.placeholder),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0 * 1.5,
                    vertical: 16.0,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              child: ListView(
                children: [
                  // For demo
                  ...List.generate(
                    demoContactsImage.length,
                    (index) => CallHistoryCard(
                      name: "Darlene Robert",
                      image: demoContactsImage[index],
                      time: local.t('homeMinutesAgo'),
                      isActive: index.isEven,
                      isOutgoingCall: index.isOdd,
                      isVideoCall: index.isEven,
                      press: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    this.image,
    required this.press,
  });

  final String name, time;
  final String? image;
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
        CircleAvatar(
          radius: radius,
          backgroundImage: (image != null && image!.isNotEmpty)
              ? NetworkImage(image!)
              : null,
          child: (image == null || image!.isEmpty)
              ? Icon(Icons.person, size: radius, color: colors.buttonText)
              : null,
        ),
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
