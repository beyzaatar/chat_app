import 'dart:async';
import 'dart:developer';
import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/feature/call/application/call_provider.dart';
import 'package:chat_app/feature/call/application/call_state.dart';
import 'package:chat_app/feature/call/data/services/call_service.dart';
import 'package:chat_app/feature/call/presentation/widgets/call_bg.dart';
import 'package:chat_app/feature/call/presentation/widgets/call_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';

class CallPage extends ConsumerStatefulWidget {
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
  ConsumerState<CallPage> createState() => _CallPageState();
}

class _CallPageState extends ConsumerState<CallPage> {
  late Room _room;
  final _callService = CallService();
  StreamSubscription? _statusSub;
  Timer? _callTimer;
  int _callSeconds = 0;

  bool _micEnabled = true;
  bool _cameraEnabled = true;
  bool _speakerEnabled = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToRoom();
    _listenForCallEnd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(callScreenVisibleProvider.notifier).state = true;
    });
  }

  Future<void> _connectToRoom() async {
    try {
      // Mevcut aktif arama varsa room'u yeniden kullan
      final existingCall = ref.read(callStateProvider);
      if (existingCall != null && existingCall.callId == widget.callId) {
        _room = existingCall.room;
        _room.addListener(_onRoomUpdate);
        // Zaten bağlıysa state'i güncelle
        if (existingCall.isConnected) {
          setState(() => _isConnected = true);
          _startCallTimer();
        }
        return;
      }

      _room = Room();

      await _room.connect(
        'wss://chat-app-betf1ib9.livekit.cloud',
        widget.token,
      );

      await _room.localParticipant?.setMicrophoneEnabled(true);
      if (widget.isVideo) {
        await _room.localParticipant?.setCameraEnabled(true);
      }

      // Önce state'i oluştur, sonra listener ekle
      // Böylece _onRoomUpdate içindeki setConnected() null state'e düşmez
      final hasRemote = _room.remoteParticipants.isNotEmpty;

      ref
          .read(callStateProvider.notifier)
          .startCall(
            ActiveCall(
              callId: widget.callId,
              roomName: widget.roomName,
              token: widget.token,
              isVideo: widget.isVideo,
              calleeName: widget.callerName,
              calleeAvatar: widget.callerImage,
              startTime: DateTime.now(),
              room: _room,
            ),
          );

      // Karşı taraf zaten odadaysa (callee durumu) hemen connected yap
      if (hasRemote) {
        setState(() => _isConnected = true);
        _startCallTimer();
        ref.read(callStateProvider.notifier).setConnected();
      }

      // Listener'ı en son ekle — state artık hazır
      _room.addListener(_onRoomUpdate);
    } catch (e) {
      log('❌ Room bağlantı hatası: $e');
      setState(() => _isConnected = true);
    }
  }

  void _onRoomUpdate() {
    setState(() {});

    // Karşı taraf odaya katılınca timer başlat
    if (_room.remoteParticipants.isNotEmpty && !_isConnected) {
      setState(() => _isConnected = true);
      _startCallTimer();
      ref.read(callStateProvider.notifier).setConnected();
    }

    // Karşı taraf ayrılınca aramayı bitir
    if (_room.remoteParticipants.isEmpty && _isConnected) {
      _endCall();
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    final activeCall = ref.read(callStateProvider);
    if (activeCall != null) {
      _callSeconds = DateTime.now().difference(activeCall.startTime).inSeconds;
    } else {
      _callSeconds = 0;
    }
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _callSeconds++);
    });
  }

  String _formatDuration() {
    final m = (_callSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_callSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _listenForCallEnd() {
    _statusSub = _callService.listenCallStatus(widget.callId).listen((status) {
      log('📞 Call status: $status');
      if (status == 'ended' || status == 'rejected') _leaveRoom();
    });
  }

  Future<void> _leaveRoom() async {
    try {
      await _room.disconnect();
    } catch (_) {}
    if (!mounted) return;
    ref.read(callStateProvider.notifier).endCall();
    ref.read(callScreenVisibleProvider.notifier).state = false;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/entry-point');
    }
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
    _callTimer?.cancel();
    _statusSub?.cancel();
    _room.removeListener(_onRoomUpdate);
    // Room'u dispose etme — floating bar hâlâ kullanıyor.
    // Room yalnızca endCall() ile dispose edilir.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(callScreenVisibleProvider.notifier).state = false;
        }
      },
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        extendBodyBehindAppBar: true,
        body: CallBg(
          image: widget.isVideo && _isConnected
              ? _buildRemoteVideo()
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
                if (!widget.isVideo || !_isConnected)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: widget.callerImage.isNotEmpty
                        ? NetworkImage(widget.callerImage)
                        : null,
                    child: widget.callerImage.isEmpty
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                const SizedBox(height: 16),
                Text(
                  widget.callerName.isNotEmpty
                      ? widget.callerName
                      : 'Bilinmeyen',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: colors.buttonText),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isConnected ? _formatDuration() : 'Aranıyor',
                      style: TextStyle(color: colors.placeholder),
                    ),
                    if (!_isConnected) ...[
                      const SizedBox(width: 4),
                      _AnimatedDots(color: colors.placeholder),
                    ],
                  ],
                ),
                const Spacer(),
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
                        press: () {
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
                            _cameraEnabled
                                ? Icons.videocam
                                : Icons.videocam_off,
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
