import 'dart:async';
import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

enum CallType { audio, video }

class CallService {
  final _supabase = Supabase.instance.client;
  final _uuid = const Uuid();

  String get _currentUserId => _supabase.auth.currentUser!.id;

  // Arama başlat
  Future<Map<String, dynamic>> initiateCall({
    required String calleeId,
    required CallType type,
  }) async {
    final roomName = 'room_${_uuid.v4()}';

    final call = await _supabase
        .from('calls')
        .insert({
          'caller_id': _currentUserId,
          'callee_id': calleeId,
          'call_type': type.name,
          'room_name': roomName,
          'status': 'ringing',
        })
        .select()
        .single();

    return call;
  }

  // Aramayı kabul et
  Future<void> acceptCall(String callId) async {
    await _supabase
        .from('calls')
        .update({
          'status': 'accepted',
          'started_at': DateTime.now().toIso8601String(),
        })
        .eq('id', callId);
  }

  // Aramayı reddet
  Future<void> rejectCall(String callId) async {
    await _supabase
        .from('calls')
        .update({
          'status': 'rejected',
          'ended_at': DateTime.now().toIso8601String(),
        })
        .eq('id', callId);
  }

  // Aramayı bitir
  Future<void> endCall(String callId) async {
    await _supabase
        .from('calls')
        .update({
          'status': 'ended',
          'ended_at': DateTime.now().toIso8601String(),
        })
        .eq('id', callId);
  }

  // LiveKit token al
  Future<String> getLiveKitToken({
    required String roomName,
    required String callId,
  }) async {
    // Session'ı yenile
    await _supabase.auth.refreshSession();
    final session = _supabase.auth.currentSession;

    if (session == null) throw Exception('Oturum bulunamadı');

    log('🔑 Access token: ${session.accessToken.substring(0, 20)}...');

    final response = await _supabase.functions.invoke(
      'livekit-token',
      body: {'roomName': roomName, 'callId': callId},
      headers: {'Authorization': 'Bearer ${session.accessToken}'},
    );

    log('📡 Response status: ${response.status}');
    log('📡 Response data: ${response.data}');

    if (response.status != 200) {
      throw Exception('Token alınamadı: ${response.data}');
    }

    return response.data['token'] as String;
  }

  // Gelen aramaları dinle
  Stream<Map<String, dynamic>?> listenForIncomingCalls() {
    log('👂 Dinleme başladı, user: $_currentUserId');

    DateTime.now().subtract(const Duration(seconds: 30)).toIso8601String();

    return _supabase.from('calls').stream(primaryKey: ['id'])
    // ← .eq() kaldırıldı, Dart tarafında filtreleriz
    .map((rows) {
      log('📊 Stream güncellendi, toplam kayıt: ${rows.length}');

      // Tüm kayıtları yazdır
      for (final r in rows) {
        log(
          '  ID: ${r['id']} | callee: ${r['callee_id']} | status: ${r['status']}',
        );
      }

      final ringing = rows
          .where(
            (r) =>
                r['callee_id'] == _currentUserId &&
                r['status'] == 'ringing' &&
                r['created_at'] != null &&
                DateTime.now()
                        .difference(DateTime.parse(r['created_at']))
                        .inSeconds <
                    30,
          )
          .toList();

      log('📲 Ringing kayıt: ${ringing.length}, currentUser: $_currentUserId');
      return ringing.isNotEmpty ? ringing.first : null;
    });
  }

  // Aramanın durumunu dinle
  Stream<String> listenCallStatus(String callId) {
    return _supabase
        .from('calls')
        .stream(primaryKey: ['id'])
        .eq('id', callId)
        .map(
          (rows) => rows.isNotEmpty ? rows.first['status'] as String : 'ended',
        );
  }

  // Geçmiş aramaları getir
  Future<List<Map<String, dynamic>>> getCallHistory() async {
    try {
      final data = await _supabase
          .from('calls')
          .select('''
      *,
      caller:caller_id(id, full_name, username, email, avatar_url),
      callee:callee_id(id, full_name, username, email, avatar_url)
    ''')
          .or('caller_id.eq.$_currentUserId,callee_id.eq.$_currentUserId')
          .neq('status', 'ringing')
          .order('created_at', ascending: false)
          .limit(50);

      log('📞 Gelen veri: $data');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      log('❌ Hata: $e');
      return [];
    }
  }
}
