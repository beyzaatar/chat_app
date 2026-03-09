import 'dart:developer';

import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/feature/call/data/call_permissions.dart';
import 'package:chat_app/feature/call/data/services/call_service.dart';
import 'package:chat_app/feature/call/presentation/pages/call_search_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({super.key});

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  final _callService = CallService();
  List<Map<String, dynamic>> _calls = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCalls();
  }

  Future<void> _loadCalls() async {
    try {
      final calls = await _callService.getCallHistory();
      log('📋 Call sayısı: ${calls.length}');
      setState(() {
        _calls = calls;
        _loading = false;
      });
    } catch (e) {
      log('❌ _loadCalls hata: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _startCall({
    required String calleeId,
    required String calleeName,
    required String? calleeAvatar,
    required bool isVideo,
  }) async {
    final hasPermission = await requestCallPermissions(isVideo);
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mikrofon/kamera izni gerekiyor')),
        );
      }
      return;
    }

    try {
      final call = await _callService.initiateCall(
        calleeId: calleeId,
        type: isVideo ? CallType.video : CallType.audio,
      );

      // 30 saniye sonra cevap gelmezse missed yap
      Future.delayed(const Duration(seconds: 30), () async {
        final status = await _callService.getCallStatus(call['id']);
        if (status == 'ringing') {
          await _callService.endCall(call['id']);
        }
      });

      final token = await _callService.getLiveKitToken(
        roomName: call['room_name'],
        callId: call['id'],
      );
      if (mounted) {
        context.push(
          '/call',
          extra: {
            'callId': call['id'],
            'roomName': call['room_name'],
            'token': token,
            'isVideo': isVideo,
            'callerName': calleeName,
            'callerImage': calleeAvatar,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Arama başlatılamadı: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final local = AppLocalizations.of(context)!;
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;

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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadCalls,
                child: ListView.builder(
                  itemCount: _calls.length,
                  itemBuilder: (context, index) {
                    final call = _calls[index];
                    final isOutgoing = call['caller_id'] == currentUserId;
                    final other = isOutgoing ? call['callee'] : call['caller'];
                    final fullName =
                        other?['full_name'] ??
                        other?['username'] ??
                        other?['email'] ??
                        'Bilinmeyen';
                    final avatarUrl = other?['avatar_url'];

                    return CallHistoryCard(
                      name: fullName,
                      image: avatarUrl,
                      time: _formatTime(call['created_at']),
                      isActive: false,
                      isOutgoingCall: isOutgoing,
                      isVideoCall: call['call_type'] == 'video',
                      press: () => _startCall(
                        calleeId: other?['id'] ?? '',
                        calleeName: fullName,
                        calleeAvatar: avatarUrl,
                        isVideo: call['call_type'] == 'video',
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  String _formatTime(String? isoDate) {
    if (isoDate == null) return '';
    final date = DateTime.parse(isoDate);
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    return '${diff.inDays} gün önce';
  }
}
