import 'package:flutter/material.dart';
import 'message_attachment_card.dart';

class MessageAttachment extends StatelessWidget {
  const MessageAttachment({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MessageAttachmentCard(
            iconData: Icons.insert_drive_file,
            title: "Belge",
            press: () {},
          ),
          MessageAttachmentCard(
            iconData: Icons.image,
            title: "Galeri",
            press: () {},
          ),
          MessageAttachmentCard(
            iconData: Icons.headset,
            title: "Ses Kaydı",
            press: () {},
          ),
          MessageAttachmentCard(
            iconData: Icons.videocam,
            title: "Video",
            press: () {},
          ),
        ],
      ),
    );
  }
}
