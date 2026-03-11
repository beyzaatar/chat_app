import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class VoiceMessageService {
  final _supabase = Supabase.instance.client;

  /// Ses dosyasını Storage'a yükle, public URL döndür
  Future<String> uploadVoiceMessage(String filePath) async {
    final file = File(filePath);
    final fileName = '${const Uuid().v4()}.m4a';
    final userId = _supabase.auth.currentUser!.id;
    final storagePath = '$userId/$fileName';

    await _supabase.storage
        .from('voice_messages')
        .upload(
          storagePath,
          file,
          fileOptions: const FileOptions(contentType: 'audio/m4a'),
        );

    return _supabase.storage.from('voice_messages').getPublicUrl(storagePath);
  }

  /// Mesajı DB'ye kaydet
  Future<void> sendVoiceMessage({
    required String roomId,
    required String audioUrl,
    required int durationMs,
  }) async {
    final userId = _supabase.auth.currentUser!.id;

    await _supabase.from('messages').insert({
      'room_id': roomId,
      'sender_id': userId,
      'message_type': 'voice',
      'audio_url': audioUrl,
      'duration_ms': durationMs,
      'content': '🎙️ Sesli mesaj', // fallback metin
    });
  }
}
