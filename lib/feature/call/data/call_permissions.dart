import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCallPermissions(bool isVideo) async {
  final permissions = [Permission.microphone];
  if (isVideo) permissions.add(Permission.camera);
  final results = await permissions.request();
  return results.values.every((s) => s == PermissionStatus.granted);
}
