import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _supabase = Supabase.instance.client;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // İzin iste
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Local notifications başlat
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(settings: initSettings);

    // Android bildirim kanalı oluştur
    const androidChannel = AndroidNotificationChannel(
      'messages_channel',
      'Mesajlar',
      description: 'Yeni mesaj bildirimleri',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    // FCM token'ı al ve kaydet
    final token = await _messaging.getToken();
    if (token != null) await _saveToken(token);
    _messaging.onTokenRefresh.listen(_saveToken);

    // Uygulama açıkken gelen mesajlar
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Bildirime tıklanınca
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  Future<void> _saveToken(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('device_tokens').upsert({
      'user_id': userId,
      'token': token,
    }, onConflict: 'user_id');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'messages_channel',
          'Mesajlar',
          channelDescription: 'Yeni mesaj bildirimleri',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final conversationId = message.data['conversationId'];
    log('Bildirime tıklandı, conversationId: $conversationId');
    // İleride router ile ilgili sohbete yönlendireceğiz
  }
}
