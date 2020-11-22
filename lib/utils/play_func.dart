import 'package:assets_audio_player/assets_audio_player.dart';

class PlayMusic {
  static AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();
  static playUrlFunc(String filePath) {
    assetsAudioPlayer.open(Audio.liveStream(filePath));
  }

  static playFileFunc(String filePath) {
    assetsAudioPlayer.open(Audio.file(filePath));
  }

  static pauseFunc() {
    assetsAudioPlayer.pause();
  }
}
