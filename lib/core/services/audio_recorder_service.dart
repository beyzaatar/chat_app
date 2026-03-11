import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;

  /// Kaydı başlat
  Future<void> startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) throw Exception('Mikrofon izni yok');

    final dir = await getTemporaryDirectory();
    _currentPath = '${dir.path}/${const Uuid().v4()}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _currentPath!,
    );
  }

  /// Kaydı durdur → dosya yolunu döndür
  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    return path;
  }

  /// Kaydı iptal et
  Future<void> cancelRecording() async {
    await _recorder.cancel();
    if (_currentPath != null) {
      final file = File(_currentPath!);
      if (await file.exists()) await file.delete();
    }
  }

  /// Kayıt devam ediyor mu?
  Future<bool> isRecording() => _recorder.isRecording();

  void dispose() => _recorder.dispose();
}
