import 'package:assets_audio_player/assets_audio_player.dart';

class PlayMusic {
  static AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();
  static playFunc(String filePath) {
    assetsAudioPlayer.open(Audio.liveStream(filePath));
  }

  static pauseFunc(String filePath) {
    assetsAudioPlayer.pause();
  }
}
