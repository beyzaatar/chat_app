import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/call_bg.dart';
import '../widgets/call_option.dart';

class AudioCallingPage extends StatelessWidget {
  const AudioCallingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      extendBodyBehindAppBar: true,
      body: CallBg(
        image: Image.network(
          "https://images.unsplash.com/photo-1557683316-973673baf926?w=1200&h=2000&fit=crop",
          fit: BoxFit.cover,
        ),

        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&h=450&fit=crop",
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                "Ralph Edwards",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: colors.buttonText),
              ),
              const SizedBox(height: 16.0 / 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Aranıyor", style: TextStyle(color: colors.placeholder)),
                  SizedBox(width: 4),
                  _AnimatedDots(color: colors.placeholder),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0 * 2,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CallOption(
                      icon: const Icon(Icons.volume_down),
                      press: () {},
                    ),
                    CallOption(icon: const Icon(Icons.mic), press: () {}),
                    CallOption(
                      icon: const Icon(Icons.videocam_off),
                      press: () {},
                    ),
                    CallOption(
                      icon: const Icon(Icons.call_end, color: Colors.white),
                      color: Color(0xFFF03738),
                      press: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedDots extends StatefulWidget {
  final Color? color;

  const _AnimatedDots({this.color});

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final opacity = (_controller.value - delay).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                '•',
                style: TextStyle(
                  color: widget.color?.withValues(
                    alpha: opacity > 0.5 ? 1.0 : 0.3,
                  ),
                  fontSize: 16,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
