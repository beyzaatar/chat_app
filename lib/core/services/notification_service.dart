import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _supabase = Supabase.instance.client;

  Future<void> initialize() async {
    //izin isteme
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    //fcm token al ve kaydet
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveToken(token);
    }

    //token yenilenince güncelle
    _messaging.onTokenRefresh.listen(_saveToken);

    //uygulama açıkken gelen mesajlar
    FirebaseMessaging.onMessage.listen(_handleForeGroundMessage);

    //bildirime tıklanınca (uygulama arka planda)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  Future<void> _saveToken(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) return;

    await _supabase.from('device_tokens').upsert({
      'user_id': userId,
      'token': token,
    }, onConflict: 'user_id');
  }

  void _handleForeGroundMessage(RemoteMessage message) {
    log('Foreground message received: ${message.notification?.title}');
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    log('Message opened from background: ${message.notification?.title}');
  }
}
