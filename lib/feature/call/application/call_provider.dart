import 'package:chat_app/feature/call/application/call_notifier.dart';
import 'package:chat_app/feature/call/application/call_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final callStateProvider = StateNotifierProvider<CallStateNotifier, ActiveCall?>(
  (ref) => CallStateNotifier(),
);

final callScreenVisibleProvider = StateProvider<bool>((ref) => false);
