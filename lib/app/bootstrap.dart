import 'dart:developer';

import 'package:chat_app/app/app.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Background mesaj handler — main dışında olmalı
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Background mesaj: ${message.messageId}');
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase başlat
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Background handler kaydet
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Supabase.initialize(
    url: 'https://xjeuvywlpnxnvortsyll.supabase.co',
    anonKey: 'sb_publishable_gMuOPyRETBv93HQC6XEPRA_Vvd0d8H8',
  );

  runApp(const ProviderScope(child: App()));
}
