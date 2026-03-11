import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Duration? get duration => _player.duration;

  Future<void> play(String url) async {
    if (_player.playing) await _player.stop();
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();

  Future<void> seek(Duration position) => _player.seek(position);

  bool get isPlaying => _player.playing;

  void dispose() => _player.dispose();
}
