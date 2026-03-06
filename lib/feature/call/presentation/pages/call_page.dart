import 'dart:async';
import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/feature/call/data/services/call_service.dart';
import 'package:chat_app/feature/call/presentation/widgets/call_bg.dart';
import 'package:chat_app/feature/call/presentation/widgets/call_option.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class CallPage extends StatefulWidget {
  final String callId;
  final String roomName;
  final String token;
  final bool isVideo;
  final String callerName;
  final String callerImage;

  const CallPage({
    super.key,
    required this.callId,
    required this.roomName,
    required this.token,
    required this.isVideo,
    this.callerName = '',
    this.callerImage = '',
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late Room _room;
  final _callService = CallService();
  StreamSubscription? _statusSub;

  bool _micEnabled = true;
  bool _cameraEnabled = true;
  bool _speakerEnabled = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToRoom();
    _listenForCallEnd();
  }

  Future<void> _connectToRoom() async {
    _room = Room();
    _room.addListener(() => setState(() {}));

    await _room.connect(
      'wss://SIZIN_LIVEKIT_URL_INIZ.livekit.cloud', // ← kendi URL'nizi yazın
      widget.token,
    );

    await _room.localParticipant?.setMicrophoneEnabled(true);
    if (widget.isVideo) {
      await _room.localParticipant?.setCameraEnabled(true);
    }

    setState(() => _isConnected = true);
  }

  void _listenForCallEnd() {
    _statusSub = _callService.listenCallStatus(widget.callId).listen((status) {
      if (status == 'ended' || status == 'rejected') _leaveRoom();
    });
  }

  Future<void> _leaveRoom() async {
    await _room.disconnect();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _endCall() async {
    await _callService.endCall(widget.callId);
    await _leaveRoom();
  }

  Widget _buildRemoteVideo() {
    if (_room.remoteParticipants.isEmpty) return const SizedBox.shrink();

    final participant = _room.remoteParticipants.values.first;
    final videoPublication = participant.videoTrackPublications
        .where((p) => !p.muted && p.track != null)
        .firstOrNull;

    if (videoPublication?.track == null) return const SizedBox.shrink();

    return VideoTrackRenderer(videoPublication!.track as VideoTrack);
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _room.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      extendBodyBehindAppBar: true,
      body: CallBg(
        image: widget.isVideo && _isConnected
            ? _buildRemoteVideo() // ← video aramasında karşı tarafın görüntüsü
            : Image.network(
                widget.callerImage.isNotEmpty
                    ? widget.callerImage
                    : 'https://images.unsplash.com/photo-1557683316-973673baf926?w=1200&h=2000&fit=crop',
                fit: BoxFit.cover,
              ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Profil fotoğrafı (sesli aramada veya video bağlanmadan önce)
              if (!widget.isVideo || !_isConnected)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    widget.callerImage.isNotEmpty
                        ? widget.callerImage
                        : 'https://randomuser.me/api/portraits/women/1.jpg',
                  ),
                ),

              const SizedBox(height: 16),
              Text(
                widget.callerName.isNotEmpty ? widget.callerName : 'Bilinmeyen',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: colors.buttonText),
              ),
              const SizedBox(height: 8),

              // Durum göstergesi
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isConnected ? 'Bağlandı' : 'Aranıyor',
                    style: TextStyle(color: colors.placeholder),
                  ),
                  if (!_isConnected) ...[
                    const SizedBox(width: 4),
                    _AnimatedDots(color: colors.placeholder),
                  ],
                ],
              ),

              const Spacer(),

              // Kontrol butonları — mevcut CallOption widget'ınızla
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CallOption(
                      icon: Icon(
                        _speakerEnabled ? Icons.volume_up : Icons.volume_off,
                      ),
                      press: () async {
                        // Hoparlör toggle
                        setState(() => _speakerEnabled = !_speakerEnabled);
                      },
                    ),
                    CallOption(
                      icon: Icon(_micEnabled ? Icons.mic : Icons.mic_off),
                      press: () async {
                        await _room.localParticipant?.setMicrophoneEnabled(
                          !_micEnabled,
                        );
                        setState(() => _micEnabled = !_micEnabled);
                      },
                    ),
                    if (widget.isVideo)
                      CallOption(
                        icon: Icon(
                          _cameraEnabled ? Icons.videocam : Icons.videocam_off,
                        ),
                        press: () async {
                          await _room.localParticipant?.setCameraEnabled(
                            !_cameraEnabled,
                          );
                          setState(() => _cameraEnabled = !_cameraEnabled);
                        },
                      ),
                    CallOption(
                      icon: const Icon(Icons.call_end, color: Colors.white),
                      color: const Color(0xFFF03738),
                      press: _endCall,
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

// Mevcut _AnimatedDots widget'ınızı buraya taşıyın
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
