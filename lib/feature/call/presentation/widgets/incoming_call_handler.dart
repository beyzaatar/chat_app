import 'dart:async';
import 'dart:developer';
import 'package:chat_app/app/router.dart';
import 'package:chat_app/feature/call/data/services/call_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomingCallHandler extends ConsumerStatefulWidget {
  final Widget child;
  const IncomingCallHandler({super.key, required this.child});

  @override
  ConsumerState<IncomingCallHandler> createState() =>
      _IncomingCallHandlerState();
}

class _IncomingCallHandlerState extends ConsumerState<IncomingCallHandler> {
  final _callService = CallService();
  StreamSubscription? _sub;
  String? _activeCallId;

  @override
  void initState() {
    super.initState();
    log('🎧 IncomingCallHandler başladı');
    _sub = _callService.listenForIncomingCalls().listen((call) {
      log('📲 Gelen arama event: $call');
      if (call != null && call['id'] != _activeCallId) {
        _activeCallId = call['id'];

        // addPostFrameCallback yerine bunu kullan
        SchedulerBinding.instance.scheduleTask(() {
          if (mounted) _showIncomingCallDialog(call);
        }, Priority.animation);
      }
    });
  }

  void _showIncomingCallDialog(Map<String, dynamic> call) {
    log('🔔 Dialog gösteriliyor, mounted: $mounted');
    final router = ref.read(appRouterProvider);

    final navigatorState = rootNavigatorKey.currentState;
    if (navigatorState == null) {
      log('❌ NavigatorState null!');
      return;
    }

    late BuildContext dialogContext;

    showDialog(
      context: navigatorState.context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
        return PopScope(
          canPop: false, // geri tuşunu engelle
          child: AlertDialog(
            title: const Text('Gelen Arama'),
            content: Text(
              '${call['call_type'] == 'video' ? '📹 Görüntülü' : '📞 Sesli'} arama geliyor...',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  _activeCallId = null;
                  await _callService.rejectCall(call['id']);
                },
                child: const Text('Reddet', style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  _activeCallId = null;
                  await _callService.acceptCall(call['id']);
                  final token = await _callService.getLiveKitToken(
                    roomName: call['room_name'],
                    callId: call['id'],
                  );
                  router.push(
                    '/call',
                    extra: {
                      'callId': call['id'],
                      'roomName': call['room_name'],
                      'token': token,
                      'isVideo': call['call_type'] == 'video',
                      'callerName': '',
                      'callerImage': '',
                    },
                  );
                },
                child: const Text('Kabul Et'),
              ),
            ],
          ),
        );
      },
    );
    // Arama durumunu dinle — ended/rejected gelirse dialogu kapat
    _callService.listenCallStatus(call['id']).listen((status) {
      if (status == 'ended' || status == 'rejected') {
        if (dialogContext.mounted) {
          Navigator.of(dialogContext).pop();
          _activeCallId = null;
        }
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
