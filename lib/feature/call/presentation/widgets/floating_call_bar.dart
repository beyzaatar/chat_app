import 'dart:async';
import 'package:chat_app/app/router.dart';
import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/feature/call/application/call_provider.dart';
import 'package:chat_app/feature/call/data/services/call_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingCallBar extends ConsumerStatefulWidget {
  final Widget child;
  const FloatingCallBar({super.key, required this.child});

  @override
  ConsumerState<FloatingCallBar> createState() => _FloatingCallBarState();
}

class _FloatingCallBarState extends ConsumerState<FloatingCallBar> {
  final _callService = CallService();
  Timer? _timer;
  Timer? _statusTimer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    // Aktif arama varsa status'u periyodik kontrol et
    _startStatusCheck();
  }

  void _startStatusCheck() {
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final activeCall = ref.read(callStateProvider);
      if (activeCall == null) return;
      final status = await _callService.getCallStatus(activeCall.callId);
      if (status == 'ended' || status == 'rejected') {
        ref.read(callStateProvider.notifier).endCall();
        _stopTimer();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    final activeCall = ref.read(callStateProvider);
    if (activeCall == null) return;

    // Arama ne zaman başladıysa oradan say
    _seconds = DateTime.now().difference(activeCall.startTime).inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    if (mounted) setState(() => _seconds = 0);
  }

  String _formatDuration() {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeCall = ref.watch(callStateProvider);
    final callScreenVisible = ref.watch(callScreenVisibleProvider);
    final colors = Theme.of(context).extension<AppColors>()!;

    // Timer'ı karşı taraf aramayı açınca başlat, bitince durdur
    ref.listen(callStateProvider, (prev, next) {
      if (next != null &&
          next.isConnected &&
          (prev == null || !prev.isConnected)) {
        _startTimer();
      }
      if (next == null) _stopTimer();
    });

    // Zaten connected ama timer çalışmıyorsa (call page'den geri dönüş)
    if (activeCall != null &&
        activeCall.isConnected &&
        (_timer == null || !_timer!.isActive)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _startTimer();
      });
    }

    return Stack(
      children: [
        widget.child,

        // Arama ekranı kapalıysa ve aktif arama varsa bar'ı göster
        if (activeCall != null && !callScreenVisible)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              color: colors.primaryButton,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  ref
                      .read(appRouterProvider)
                      .push(
                        '/call',
                        extra: {
                          'callId': activeCall.callId,
                          'roomName': activeCall.roomName,
                          'token': activeCall.token,
                          'isVideo': activeCall.isVideo,
                          'callerName': activeCall.calleeName,
                          'callerImage': activeCall.calleeAvatar,
                        },
                      );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: activeCall.calleeAvatar.isNotEmpty
                            ? NetworkImage(activeCall.calleeAvatar)
                            : null,
                        child: activeCall.calleeAvatar.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),

                      // İsim + süre
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              activeCall.calleeName.isNotEmpty
                                  ? activeCall.calleeName
                                  : 'Bilinmeyen',
                              style: TextStyle(
                                color: colors.buttonText,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  activeCall.isVideo
                                      ? Icons.videocam
                                      : Icons.call,
                                  size: 13,
                                  color: colors.buttonText.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  activeCall.isConnected
                                      ? _formatDuration()
                                      : 'Aranıyor...',
                                  style: TextStyle(
                                    color: colors.buttonText.withValues(
                                      alpha: 0.8,
                                    ),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Mikrofon toggle
                      ValueListenableBuilder(
                        valueListenable: ValueNotifier(
                          activeCall.room.localParticipant
                                  ?.isMicrophoneEnabled() ??
                              true,
                        ),
                        builder: (context, micEnabled, _) {
                          return IconButton(
                            icon: Icon(
                              micEnabled ? Icons.mic : Icons.mic_off,
                              color: colors.buttonText,
                            ),
                            onPressed: () async {
                              await activeCall.room.localParticipant
                                  ?.setMicrophoneEnabled(!micEnabled);
                              setState(() {});
                            },
                          );
                        },
                      ),

                      // Kapat
                      IconButton(
                        icon: const Icon(Icons.call_end, color: Colors.red),
                        onPressed: () async {
                          await _callService.endCall(activeCall.callId);
                          ref.read(callStateProvider.notifier).endCall();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
