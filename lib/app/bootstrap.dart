import 'package:chat_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xjeuvywlpnxnvortsyll.supabase.co',
    anonKey: 'sb_publishable_gMuOPyRETBv93HQC6XEPRA_Vvd0d8H8',
  );

  runApp(const ProviderScope(child: App()));
}
