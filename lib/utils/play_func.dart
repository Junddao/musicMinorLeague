import 'package:assets_audio_player/assets_audio_player.dart';

class PlayMusic {
  static AssetsAudioPlayer _assetsAudioPlayer = new AssetsAudioPlayer();
  static playUrlFunc(String filePath) {
    _assetsAudioPlayer.open(Audio.network(filePath));
  }

  static playFileFunc(String filePath) {
    _assetsAudioPlayer.open(Audio.file(filePath));
  }

  static pauseFunc() {
    _assetsAudioPlayer.pause();
  }

  static seekFunc(Duration pos) {
    _assetsAudioPlayer.seek(pos);
  }

  static Stream getCurrentStream() {
    return _assetsAudioPlayer.current;
  }

  static Stream getPositionStream() {
    return _assetsAudioPlayer.currentPosition;
  }

  static Stream getSongLengthStream() {
    return _assetsAudioPlayer.realtimePlayingInfos;
  }

  static AssetsAudioPlayer assetsAudioPlayer() {
    return _assetsAudioPlayer;
  }
}
