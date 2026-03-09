import 'package:livekit_client/livekit_client.dart';

class ActiveCall {
  final String callId;
  final String roomName;
  final String token;
  final bool isVideo;
  final String calleeName;
  final String calleeAvatar;
  final DateTime startTime;
  final Room room;
  final bool isConnected;

  ActiveCall({
    required this.callId,
    required this.roomName,
    required this.token,
    required this.isVideo,
    required this.calleeName,
    required this.calleeAvatar,
    required this.startTime,
    required this.room,
    this.isConnected = false,
  });
}
