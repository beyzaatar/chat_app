import 'package:chat_app/feature/call/application/call_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class CallStateNotifier extends StateNotifier<ActiveCall?> {
  CallStateNotifier() : super(null);

  void startCall(ActiveCall call) => state = call;
  void endCall() {
    state?.room.dispose();
    state = null;
  }

  void setConnected() {
    if (state == null) return;
    state = ActiveCall(
      callId: state!.callId,
      roomName: state!.roomName,
      token: state!.token,
      isVideo: state!.isVideo,
      calleeName: state!.calleeName,
      calleeAvatar: state!.calleeAvatar,
      startTime: DateTime.now(), // ← gerçek bağlantı zamanı
      room: state!.room,
      isConnected: true,
    );
  }
}
