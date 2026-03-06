import 'dart:async';
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
    final response = await _supabase.functions.invoke(
      'livekit-token',
      body: {'roomName': roomName, 'callId': callId},
    );
    return response.data['token'] as String;
  }

  // Gelen aramaları dinle
  Stream<Map<String, dynamic>?> listenForIncomingCalls() {
    return _supabase
        .from('calls')
        .stream(primaryKey: ['id'])
        .eq('callee_id', _currentUserId)
        .map((rows) {
          final ringing = rows.where((r) => r['status'] == 'ringing').toList();
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
          .select('*')
          .or('caller_id.eq.$_currentUserId,callee_id.eq.$_currentUserId')
          .neq('status', 'ringing')
          .order('created_at', ascending: false)
          .limit(50);

      print('📞 Gelen veri: $data');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('❌ Hata: $e');
      return [];
    }
  }
}
