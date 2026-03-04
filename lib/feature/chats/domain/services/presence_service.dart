import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class PresenceService {
  final _client = Supabase.instance.client;
  RealtimeChannel? _channel;

  Stream<List<Map<String, dynamic>>> trackAndListen() {
    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    final user = _client.auth.currentUser!;

    _channel = _client.channel(
      'online-users',
      opts: const RealtimeChannelConfig(self: true),
    );

    _channel!
        .onPresenceSync((payload) {
          final state = _channel!.presenceState();
          final users = state
              .expand((presenceState) => presenceState.presences)
              .map((p) => Map<String, dynamic>.from(p.payload))
              .toList();
          controller.add(users);
        })
        .subscribe((status, [error]) async {
          if (status == RealtimeSubscribeStatus.subscribed) {
            await _channel!.track({
              'user_id': user.id,
              'email': user.email,
              'online_at': DateTime.now().toUtc().toIso8601String(),
            });

            // Update last_seen_at when going online
            try {
              await _client
                  .from('profiles')
                  .update({
                    'last_seen_at': DateTime.now().toUtc().toIso8601String(),
                  })
                  .eq('id', user.id);
            } catch (e) {
              // Ignore errors when updating last_seen_at
            }
          }
        });

    return controller.stream;
  }

  Future<void> dispose() async {
    // Update last_seen_at before going offline
    final user = _client.auth.currentUser;
    if (user != null) {
      try {
        await _client
            .from('profiles')
            .update({'last_seen_at': DateTime.now().toUtc().toIso8601String()})
            .eq('id', user.id);
      } catch (e) {
        // Ignore errors when updating last_seen_at
      }
    }

    await _channel?.untrack();
    await _client.removeChannel(_channel!);
    _channel = null;
  }
}
