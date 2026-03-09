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
                    //final otherEmail = other?['email'] ?? 'Bilinmeyen';

                    return CallHistoryCard(
                      name: other?['full_name'] ?? 'Bilinmeyen',
                      image:
                          other?['avatar_url'] ??
                          'https://randomuser.me/api/portraits/women/1.jpg',
                      time: _formatTime(call['created_at']),
                      isActive: false,
                      isOutgoingCall: isOutgoing,
                      isVideoCall: call['call_type'] == 'video',
                      press: () async {
                        // Arama başlat
                        final hasPermission = await requestCallPermissions(
                          call['call_type'] == 'video',
                        );
                        if (!hasPermission) return;

                        final newCall = await _callService.initiateCall(
                          calleeId: other['id'],
                          type: call['call_type'] == 'video'
                              ? CallType.video
                              : CallType.audio,
                        );
                        final token = await _callService.getLiveKitToken(
                          roomName: newCall['room_name'],
                          callId: newCall['id'],
                        );
                        if (mounted) {
                          this.context.push(
                            '/call',
                            extra: {
                              'callId': newCall['id'],
                              'roomName': newCall['room_name'],
                              'token': token,
                              'isVideo': call['call_type'] == 'video',
                              'callerName': other?['full_name'] ?? 'Bilinmeyen',
                              'callerImage':
                                  other?['avatar_url'] ??
                                  'https://randomuser.me/api/portraits/women/1.jpg',
                            },
                          );
                        }
                      },
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
